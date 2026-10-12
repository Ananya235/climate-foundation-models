
import cdsapi
from pathlib import Path

dataset = "reanalysis-era5-single-levels"

request = {
    "product_type": ["reanalysis"],
    "variable": [
        "10m_u_component_of_wind",
        "10m_v_component_of_wind",
        "2m_dewpoint_temperature",
        "2m_temperature",
        "mean_sea_level_pressure",
        "sea_surface_temperature",
        "total_precipitation",
    ],
    "year": ["2025"],
    "month": ["10"],
    "day": [
        "01", "02", "03", "04", "05",
        "06", "07", "08", "09", "10"
    ],
    "time": ["00:00", "06:00", "12:00", "18:00"],
    "data_format": "netcdf",
    "download_format": "unarchived",
    "area": [14, 79, 11, 81],
}

output_path = Path("data/raw/era5_chennai_sample.nc")
output_path.parent.mkdir(parents=True, exist_ok=True)

client = cdsapi.Client()
client.retrieve(dataset, request).download(str(output_path))

print(f"Download saved to: {output_path}")
