"""
ERA5 Data Download Script

Downloads a small regional subset of ERA5 data from
the Copernicus Climate Data Store.

The full ERA5 dataset is NOT stored in this repository.
"""

import cdsapi


# Chennai / Tamil Nadu region
# North, West, South, East
AREA = [14.0, 79.0, 11.0, 81.0]

YEAR = "2025"
MONTH = "10"

VARIABLES = [
    "2m_temperature",
    "2m_dewpoint_temperature",
    "10m_u_component_of_wind",
    "10m_v_component_of_wind",
    "mean_sea_level_pressure",
    "total_precipitation",
]


def download_era5():
    client = cdsapi.Client()

    client.retrieve(
        "reanalysis-era5-single-levels",
        {
            "product_type": ["reanalysis"],
            "variable": VARIABLES,
            "year": [YEAR],
            "month": [MONTH],
            "day": [
                "01", "02", "03", "04", "05",
                "06", "07", "08", "09", "10"
            ],
            "time": [
                "00:00", "06:00", "12:00", "18:00"
            ],
            "data_format": "netcdf",
            "download_format": "unarchived",
            "area": AREA,
        },
        "data/raw/era5_chennai_sample.nc",
    )


if __name__ == "__main__":
    download_era5()