-- Climate Foundation Models
-- Initial PostgreSQL/PostGIS database schema

CREATE EXTENSION IF NOT EXISTS postgis;

-- Stores geographical locations such as weather stations
-- and climate grid locations.

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    elevation DOUBLE PRECISION,
    geometry GEOMETRY(Point, 4326)
);

-- Stores climate variables.

CREATE TABLE variables (
    variable_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    unit VARCHAR(50)
);

-- Stores information about the source datasets.

CREATE TABLE datasets (
    dataset_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    source VARCHAR(255),
    version VARCHAR(100),
    spatial_resolution VARCHAR(100),
    temporal_resolution VARCHAR(100)
);

-- Stores climate/weather observations.

CREATE TABLE weather_observations (
    observation_id BIGSERIAL PRIMARY KEY,
    location_id INTEGER REFERENCES locations(location_id),
    timestamp TIMESTAMP NOT NULL,
    variable_id INTEGER REFERENCES variables(variable_id),
    value DOUBLE PRECISION,
    dataset_id INTEGER REFERENCES datasets(dataset_id)
);