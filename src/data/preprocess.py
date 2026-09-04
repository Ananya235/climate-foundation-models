"""
ERA5 preprocessing utilities.

Loads the downloaded ERA5 NetCDF file and prepares
the data for database ingestion.
"""

import xarray as xr


def load_era5(file_path):
    """Load an ERA5 NetCDF dataset."""
    dataset = xr.open_dataset(file_path)

    print("Dataset loaded successfully.")
    print(dataset)

    return dataset


def inspect_dataset(dataset):
    """Display basic dataset information."""
    print("\nDimensions:")
    print(dataset.dims)

    print("\nVariables:")
    print(list(dataset.data_vars))


if __name__ == "__main__":
    file_path = "data/raw/era5_chennai_sample.nc"

    dataset = load_era5(file_path)
    inspect_dataset(dataset)