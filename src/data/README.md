# Data Pipeline

This module will contain scripts for acquiring and preprocessing
climate datasets used by the project.

## Planned Data Sources

- ERA5 / ERA5-Land
- Local weather observations
- Satellite/geospatial data if feasible

## Planned Processing

1. Download selected regional data.
2. Clean and validate observations.
3. Convert data into a database-compatible format.
4. Load the processed data into PostgreSQL/PostGIS.