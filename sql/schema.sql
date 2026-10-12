-- ============================================================
-- CLIMATE FOUNDATION MODELS
-- PostgreSQL + PostGIS Database Schema
-- ============================================================

-- WARNING:
-- This section resets the project tables.
-- Run this only when you want to rebuild the database.

DROP TABLE IF EXISTS weather_observations CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS variables CASCADE;
DROP TABLE IF EXISTS datasets CASCADE;


-- ============================================================
-- 1. DATASETS
-- Stores information about the climate-data source.
-- Example: ERA5, ERA5-Land, local weather observations.
-- ============================================================

CREATE TABLE datasets (
    dataset_id SERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL,

    source VARCHAR(255),

    version VARCHAR(100),

    spatial_resolution VARCHAR(100),

    temporal_resolution VARCHAR(100),

    description TEXT
);


-- ============================================================
-- 2. LOCATIONS
-- Stores geographic locations associated with observations.
-- PostGIS geography allows distance-based spatial queries.
-- ============================================================

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,

    latitude DOUBLE PRECISION NOT NULL,

    longitude DOUBLE PRECISION NOT NULL,

    elevation DOUBLE PRECISION,

    geography GEOGRAPHY(Point, 4326) NOT NULL
);


-- ============================================================
-- 3. VARIABLES
-- Stores climate variables.
-- ============================================================

CREATE TABLE variables (
    variable_id SERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE,

    unit VARCHAR(50),

    description TEXT
);


-- ============================================================
-- 4. WEATHER OBSERVATIONS
-- Main climate-data table.
--
-- Each record represents:
-- location + timestamp + climate variable + value + dataset
-- ============================================================

CREATE TABLE weather_observations (
    observation_id BIGSERIAL PRIMARY KEY,

    location_id INTEGER NOT NULL
        REFERENCES locations(location_id),

    timestamp TIMESTAMP NOT NULL,

    variable_id INTEGER NOT NULL
        REFERENCES variables(variable_id),

    value DOUBLE PRECISION,

    dataset_id INTEGER NOT NULL
        REFERENCES datasets(dataset_id)
);


-- ============================================================
-- BASIC DATA VALIDATION
-- ============================================================

ALTER TABLE locations
ADD CONSTRAINT valid_latitude
CHECK (latitude BETWEEN -90 AND 90);

ALTER TABLE locations
ADD CONSTRAINT valid_longitude
CHECK (longitude BETWEEN -180 AND 180);


-- ============================================================
-- END OF SCHEMA
-- ============================================================