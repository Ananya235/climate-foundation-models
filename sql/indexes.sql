-- ============================================================
-- CLIMATE FOUNDATION MODELS
-- Database Indexes
-- ============================================================


-- ============================================================
-- 1. TEMPORAL INDEX
--
-- Speeds up queries that search by timestamp.
-- Example:
-- "Give me observations from October 2025."
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_weather_timestamp
ON weather_observations(timestamp);


-- ============================================================
-- 2. VARIABLE INDEX
--
-- Speeds up retrieval of specific climate variables.
-- Example:
-- "Give me precipitation observations."
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_weather_variable
ON weather_observations(variable_id);


-- ============================================================
-- 3. LOCATION INDEX
--
-- Speeds up joins between observations and locations.
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_weather_location
ON weather_observations(location_id);


-- ============================================================
-- 4. SPATIAL GiST INDEX
--
-- PostGIS uses GiST indexes for efficient spatial searches.
--
-- Example:
-- "Find climate observations within 25 km of Chennai."
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_locations_geography
ON locations
USING GIST (geography);


-- ============================================================
-- 5. COMPOSITE TEMPORAL + VARIABLE INDEX
--
-- Useful when climate retrieval specifies both:
--     time + variable
--
-- Example:
-- "Find precipitation during October 2025."
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_weather_timestamp_variable
ON weather_observations(timestamp, variable_id);


-- ============================================================
-- END OF INDEX DEFINITIONS
-- ============================================================