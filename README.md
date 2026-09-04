# Towards Foundation Models for Climate Intelligence

### Spatiotemporal Data Management for Hyperlocal Forecasting and Decision Support

---

## 📌 Project Overview

Climate and weather foundation models are transforming large-scale
weather and Earth-system forecasting.

This project studies the evolution of climate foundation models,
including:

- FourCastNet
- GraphCast
- Pangu-Weather
- NeuralGCM
- ClimaX
- Aurora
- Earth-observation foundation models

Alongside the literature review, we investigate the **data-management
infrastructure required to support hyperlocal climate intelligence**.

The implementation focuses on storing, indexing and efficiently
retrieving large-scale and local climate data using a
**spatiotemporal database**.

---

## 🎯 Objectives

1. Study recent foundation models for weather and climate forecasting.
2. Compare their architectures, training data, resolution and
   forecasting capabilities.
3. Identify challenges in applying foundation models to local and
   hyperlocal applications.
4. Investigate data-management requirements for climate foundation
   models.
5. Design and implement a spatiotemporal climate database using
   PostgreSQL and PostGIS.
6. Evaluate spatial, temporal and spatiotemporal data retrieval.
7. Explore how efficient data retrieval can support hyperlocal
   forecasting and decision support.

---

## 🏗️ Proposed Architecture

```text
        ERA5 / ERA5-Land
                +
        Local Weather Data
                +
     Geospatial Data (if feasible)
                │
                ▼
        Data Preprocessing
                │
                ▼
       PostgreSQL + PostGIS
                │
        ┌───────┴───────┐
        ▼               ▼
   Spatial Index    Temporal Index
        │               │
        └───────┬───────┘
                ▼
      Spatiotemporal Retrieval
                │
                ▼
      Selected Foundation Model
                │
                ▼
       Hyperlocal Forecasting
                │
                ▼
         Decision Support
