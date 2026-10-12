# Towards Foundation Models for Climate Intelligence

### Spatiotemporal Data Management for Hyperlocal Forecasting and Decision Support

## Project Overview

Climate and weather foundation models are advancing large-scale weather forecasting and Earth-system analysis. This project reviews current climate foundation models and investigates the data-management infrastructure needed to support localized climate intelligence.

The review covers models and research directions including:

- FourCastNet
- GraphCast
- Pangu-Weather
- NeuralGCM
- ClimaX
- Aurora
- Earth-observation foundation models

Alongside the literature review, the implementation investigates how climate data can be prepared, stored, indexed, and retrieved efficiently using a spatiotemporal database.

The current case study uses a regional ERA5 sample covering the Chennai/Tamil Nadu area. The longer-term objective is to evaluate how efficient spatial and temporal retrieval can support downstream forecasting and decision-support applications.

## Research Question

**What data-management and retrieval infrastructure is required for climate foundation models to support localized forecasting and decision support?**

The project's focus is on the data infrastructure and retrieval layer rather than training a large foundation model from scratch.

## Objectives

1. Review recent climate and weather foundation models.
2. Compare their architectures, datasets, spatial resolutions, and forecasting capabilities.
3. Identify challenges in adapting global climate information for regional applications.
4. Acquire and preprocess a regional ERA5 dataset.
5. Design a PostgreSQL/PostGIS data-management layer for climate observations.
6. Develop spatial, temporal, and combined retrieval queries.
7. Evaluate query performance with and without appropriate indexing.
8. Explore how the resulting infrastructure could support downstream climate-model applications.

## System Architecture

```text
ERA5 Climate Data
        |
        v
Python Data Acquisition
        |
        v
Data Preprocessing
        |
        v
Standardized Climate CSV
        |
        v
PostgreSQL + PostGIS
        |
        v
Spatial and Temporal Indexing
        |
        v
Spatiotemporal Retrieval
        |
        v
Potential Downstream Climate Model
        |
        v
Localized Forecasting and Decision Support
```

The database and retrieval components form the central implementation focus. Downstream foundation-model integration is a future extension unless otherwise documented.

## Current Implementation Status

### Completed

- Acquired a regional ERA5 sample for October 1–10, 2025.
- Selected a geographic bounding box spanning 11°–14° N and 79°–81° E.
- Downloaded instantaneous climate variables and accumulated precipitation as separate data files.
- Implemented Python preprocessing with `xarray` and `pandas`.
- Standardized the observations into a common CSV schema.
- Validated the generated CSV for missing values and duplicate observation keys.

### Dataset validation results

| Property | Current result |
|---|---|
| Source | ERA5 |
| Period | October 1–10, 2025 |
| Time interval | Six-hourly sample |
| Geographic extent | 11°–14° N, 79°–81° E |
| Grid spacing | 0.25° |
| Total observation rows | 30,240 |
| Climate variables | 7 |
| Missing values reported | 0 |
| Duplicate observation keys reported | 0 |

These figures describe the current preprocessed sample, not a complete climate dataset or a database benchmark.

### Variables included

| Variable | Description | Unit in current CSV |
|---|---|---|
| `10m_u_component_of_wind` | East-west wind component at 10 m | m s⁻¹ |
| `10m_v_component_of_wind` | North-south wind component at 10 m | m s⁻¹ |
| `2m_dewpoint_temperature` | Dewpoint temperature at 2 m | K |
| `2m_temperature` | Air temperature at 2 m | K |
| `mean_sea_level_pressure` | Mean sea-level pressure | Pa |
| `sea_surface_temperature` | Sea surface temperature | K |
| `total_precipitation` | Total precipitation | m |

Sea-surface temperature contains fewer valid observations than the other variables, which is consistent with ocean-only availability and missing values over land being excluded during preprocessing.

## Data Format

The processed dataset is stored at:

`data/processed/climate_observations.csv`

Each row represents one variable measured at a particular grid location and timestamp.

The CSV uses the following columns:

```text
timestamp,latitude,longitude,variable_name,value,unit,dataset_name
```

Timestamps are represented in UTC ISO 8601 format. The standardized format is intended to simplify subsequent database ingestion and spatiotemporal queries.

## Repository Structure

```text
climate-foundation-models/
├── data/
│   ├── raw/                 # Downloaded source data; excluded from Git
│   └── processed/
│       └── climate_observations.csv
├── literature/              # Literature review materials
├── notebooks/               # Analysis notebooks
├── sql/
│   ├── schema.sql           # Database schema
│   ├── queries.sql          # Retrieval queries
│   ├── indexes.sql          # Index definitions
│   ├── seed_data.sql        # Seed data
│   └── experiments.sql      # Benchmark experiment scripts
├── src/
│   ├── data/
│   │   ├── download_era5.py
│   │   ├── preprocess.py
│   │   └── prepare_for_db.py
│   └── database/
│       ├── database.py
│       └── ingest.py
├── requirements.txt
└── README.md
```

The presence of a script in the repository does not, by itself, mean that its database operations or experiments have been executed and validated.

## Setup

Use Python 3.12 or a compatible Python environment.

Create and activate a virtual environment:

```bash
python -m venv .venv
```

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

### Download ERA5 data

1. Create a Copernicus Climate Data Store account.
2. Accept the terms for the required ERA5 dataset.
3. Configure CDS API credentials locally using the official CDS instructions.
4. Review the request settings in `src/data/download_era5.py`.
5. Run:

```bash
python src/data/download_era5.py
```

Keep API credentials out of the repository. Raw downloaded NetCDF files are excluded from Git.

### Preprocess the data

After downloading the required instantaneous and accumulated-variable files, run:

```bash
python src/data/preprocess.py
```

The script generates:

`data/processed/climate_observations.csv`

The current preprocessing output was validated locally. Database ingestion should be tested separately.

## Database and Retrieval Evaluation

The repository contains SQL files intended to support the PostgreSQL/PostGIS implementation.

The planned evaluation includes:

- Spatial queries for geographic regions.
- Temporal queries for selected time intervals.
- Combined spatial-temporal retrieval.
- Comparisons of query performance before and after indexing.
- Scalability tests as the number of observations increases.

**Benchmark results should be reported only after the queries have been executed and their measurements recorded.** The current CSV validation counts are not query-performance results.

## Limitations and Future Work

- The current dataset is a small regional ERA5 sample rather than a comprehensive climate record.
- ERA5's 0.25° grid does not provide street-level observations or, by itself, establish street-level forecasting accuracy.
- Local station observations and additional geospatial datasets may be incorporated in future work.
- PostgreSQL/PostGIS ingestion, index validation, and retrieval benchmarks need to be documented once tested.
- Integration with a pretrained climate foundation model is a potential downstream extension and should not be interpreted as completed unless demonstrated experimentally.

## Project Focus

The intended contribution is a data-centric investigation of spatiotemporal climate-data management and retrieval, with the goal of establishing a reproducible infrastructure foundation for future climate intelligence applications.
