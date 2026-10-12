
from pathlib import Path

import pandas as pd
import xarray as xr


# Input file containing instantaneous ERA5 variables
INPUT_FILE = Path(
    "data/raw/data_stream-oper_stepType-instant.nc"
)

# Output CSV for the PostgreSQL/PostGIS pipeline
OUTPUT_FILE = Path(
    "data/processed/climate_observations.csv"
)

# Map short ERA5 variable codes to descriptive names
VARIABLE_NAMES = {
    "u10": "10m_u_component_of_wind",
    "v10": "10m_v_component_of_wind",
    "d2m": "2m_dewpoint_temperature",
    "t2m": "2m_temperature",
    "msl": "mean_sea_level_pressure",
    "sst": "sea_surface_temperature",
}


def main():
    # Create the output folder if it does not exist
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    # Open the downloaded NetCDF dataset
    dataset = xr.open_dataset(INPUT_FILE)

    rows = []

    # Convert each climate variable into observation rows
    for code, variable_name in VARIABLE_NAMES.items():

        if code not in dataset.data_vars:
            print(f"Skipping missing variable: {code}")
            continue

        # Convert this variable's grid into a table
        frame = (
            dataset[code]
            .to_dataframe(name="value")
            .reset_index()
        )

        # Remove missing measurements
        frame = frame.dropna(subset=["value"])

        # Standardize the column names
        frame = frame.rename(
            columns={"valid_time": "timestamp"}
        )

        # Store timestamps in UTC ISO format
        timestamps = pd.to_datetime(
            frame["timestamp"], utc=True
        )

        frame["timestamp"] = timestamps.dt.strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        )

        # Add metadata using the source file's units
        frame["variable_name"] = variable_name
        frame["unit"] = dataset[code].attrs.get(
            "units", "unknown"
        )
        frame["dataset_name"] = "ERA5"

        # Keep only the agreed database columns
        frame = frame[
            [
                "timestamp",
                "latitude",
                "longitude",
                "variable_name",
                "value",
                "unit",
                "dataset_name",
            ]
        ]

        rows.append(frame)

        print(
            f"Prepared {variable_name}: "
            f"{len(frame)} observations"
        )

    
    
    # Load accumulated precipitation from its separate NetCDF file
    precip_file = Path(
        "data/raw/data_stream-oper_stepType-accum.nc"
    )

    precip_dataset = xr.open_dataset(precip_file)

    try:
        # Convert precipitation grid into a table
        precip = (
            precip_dataset["tp"]
            .to_dataframe(name="value")
            .reset_index()
            .dropna(subset=["value"])
        )

        # Use the same timestamp format as the existing CSV
        precip = precip.rename(
            columns={"valid_time": "timestamp"}
        )

        precip["timestamp"] = pd.to_datetime(
            precip["timestamp"], utc=True
        ).dt.strftime("%Y-%m-%dT%H:%M:%SZ")

        # Add metadata
        precip["variable_name"] = "total_precipitation"
        precip["unit"] = precip_dataset["tp"].attrs.get(
            "units", "unknown"
        )
        precip["dataset_name"] = "ERA5"

        # Match the existing CSV schema
        precip = precip[
            [
                "timestamp",
                "latitude",
                "longitude",
                "variable_name",
                "value",
                "unit",
                "dataset_name",
            ]
        ]

        rows.append(precip)

        print(
            "Prepared total_precipitation:",
            len(precip),
            "observations"
        )

    finally:
        precip_dataset.close()

       

    # Combine all variables into one CSV AFTER precipitation is added
    if not rows:
        raise ValueError("No climate observations were found.")

    result = pd.concat(rows, ignore_index=True)

    result.to_csv(OUTPUT_FILE, index=False)

    print("\nCSV created successfully!")
    print(f"Location: {OUTPUT_FILE}")
    print(f"Total observations: {len(result)}")
    print(f"Unique variables: {result['variable_name'].nunique()}")
    print(f"Missing values: {result.isna().sum().sum()}")
    print("\nFirst five rows:")
    print(result.head())


if __name__ == "__main__":
    main()    



