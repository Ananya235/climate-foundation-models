# Towards Foundation Models for Climate Intelligence

## A Spatiotemporal Data Management Framework for Hyperlocal Forecasting and Decision Support

### Project Overview

This project studies the evolution of foundation models for weather
and climate intelligence, including FourCastNet, GraphCast,
Pangu-Weather, NeuralGCM, ClimaX, Aurora and Earth-observation
foundation models.

The implementation focuses on the data-management challenges involved
in supporting hyperlocal climate applications.

Large climate datasets are heterogeneous and spatiotemporal in nature.
The project therefore investigates how climate data can be efficiently
stored, indexed and retrieved to provide relevant local context for
foundation-model-based climate intelligence.

### Proposed Architecture

ERA5 / ERA5-Land
        +
Local Weather Observations
        +
Geospatial Data (if feasible)
        |
        v
Data Preprocessing
        |
        v
PostgreSQL + PostGIS
        |
        +----------------+
        |                |
        v                v
Spatial Indexing   Temporal Indexing
        |                |
        +-------+--------+
                |
                v
     Spatiotemporal Retrieval
                |
                v
      Selected Foundation Model
                |
                v
       Hyperlocal Forecasting
                |
                v
         Decision Support

### Objectives

1. Study recent foundation models for weather and climate forecasting.
2. Compare their architectures, datasets, resolution, forecasting
   capabilities and generality.
3. Identify limitations of current foundation models for local and
   hyperlocal applications.
4. Investigate data-management requirements for climate foundation
   models.
5. Implement a spatiotemporal climate database using PostgreSQL
   and PostGIS.
6. Evaluate spatial, temporal and spatiotemporal retrieval performance.
7. Explore how efficient climate-data retrieval can support
   hyperlocal forecasting and decision support.

### Dataset

The initial climate dataset will be ERA5 / ERA5-Land.

Potential additional data sources include local weather observations
and satellite/geospatial data where suitable datasets are available.

The project will initially focus on a regional case study, with
Chennai/Tamil Nadu being considered because of its relevance to
monsoon and extreme-rainfall applications.

### Database Component

The database will organize climate observations using entities such as:

- Locations
- Weather observations
- Climate variables
- Datasets

PostgreSQL will provide the relational database layer and PostGIS
will provide spatial data handling and spatial indexing.

### Planned Experiments

#### 1. Temporal Indexing

Compare sequential scans with B-tree timestamp indexing.

#### 2. Spatial Indexing

Compare naive spatial searches with PostGIS GiST spatial indexing.

#### 3. Spatiotemporal Retrieval

Evaluate queries involving location, time and climate variables.

#### 4. Scalability

Evaluate retrieval performance at increasing dataset sizes.

Metrics may include:

- Query latency
- Storage
- Index size
- Data ingestion cost

### Current Status

- Project repository established
- Python development environment configured
- Initial project structure created
- Initial database schema designed
- Climate-data query examples created
- ERA5 data acquisition pipeline started
- PostgreSQL/PostGIS implementation in progress

### Future Work

1. Finalize the climate and local observation datasets.
2. Acquire and preprocess the initial regional dataset.
3. Set up PostgreSQL/PostGIS.
4. Ingest climate observations into the database.
5. Implement spatial and temporal indexes.
6. Perform DBMS retrieval and scalability experiments.
7. Select and integrate a suitable pretrained climate foundation model.
8. Investigate hyperlocal climate intelligence and decision support.
