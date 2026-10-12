-- ============================================================
-- CLIMATE FOUNDATION MODELS
-- Sample Climate Data
--
-- NOTE:
-- This is development/test data.
-- It will later be replaced/augmented with actual ERA5 data.
-- ============================================================


-- ============================================================
-- 1. DATASETS
-- ============================================================

INSERT INTO datasets
(name, source, version, spatial_resolution, temporal_resolution, description)
VALUES
(
    'ERA5',
    'Copernicus Climate Change Service',
    '2025',
    '0.25 degree',
    'Hourly',
    'Global atmospheric reanalysis dataset'
),

(
    'Local Weather Observations',
    'Prototype Dataset',
    '1.0',
    'Point observations',
    'Hourly',
    'Sample local observations for database testing'
);


-- ============================================================
-- 2. CLIMATE VARIABLES
-- ============================================================

INSERT INTO variables
(name, unit, description)
VALUES
(
    '2m_temperature',
    'K',
    'Temperature at 2 metres above the surface'
),

(
    '2m_dewpoint_temperature',
    'K',
    'Dewpoint temperature at 2 metres'
),

(
    '10m_u_component_of_wind',
    'm/s',
    'East-west component of wind at 10 metres'
),

(
    '10m_v_component_of_wind',
    'm/s',
    'North-south component of wind at 10 metres'
),

(
    'mean_sea_level_pressure',
    'Pa',
    'Mean sea level atmospheric pressure'
),

(
    'total_precipitation',
    'm',
    'Total precipitation'
);


-- ============================================================
-- 3. LOCATIONS
-- Chennai and nearby locations
-- ============================================================

INSERT INTO locations
(latitude, longitude, elevation, geography)
VALUES
(
    13.0827,
    80.2707,
    6,
    ST_SetSRID(ST_Point(80.2707, 13.0827), 4326)::geography
),

(
    12.9249,
    80.1000,
    12,
    ST_SetSRID(ST_Point(80.1000, 12.9249), 4326)::geography
),

(
    13.1147,
    80.1098,
    15,
    ST_SetSRID(ST_Point(80.1098, 13.1147), 4326)::geography
),

(
    13.0108,
    80.2350,
    8,
    ST_SetSRID(ST_Point(80.2350, 13.0108), 4326)::geography
),

(
    12.9716,
    80.2215,
    10,
    ST_SetSRID(ST_Point(80.2215, 12.9716), 4326)::geography
);


-- ============================================================
-- 4. SAMPLE TEMPERATURE OBSERVATIONS
-- ============================================================

INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-01 00:00:00',
    v.variable_id,
    298.15,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 13.0827
  AND l.longitude = 80.2707
  AND v.name = '2m_temperature'
  AND d.name = 'ERA5';


INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-01 06:00:00',
    v.variable_id,
    300.15,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 13.0827
  AND l.longitude = 80.2707
  AND v.name = '2m_temperature'
  AND d.name = 'ERA5';


INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-01 12:00:00',
    v.variable_id,
    303.15,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 13.0827
  AND l.longitude = 80.2707
  AND v.name = '2m_temperature'
  AND d.name = 'ERA5';


-- ============================================================
-- 5. SAMPLE PRECIPITATION OBSERVATIONS
-- ============================================================

INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-01 00:00:00',
    v.variable_id,
    0.0002,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 13.0827
  AND l.longitude = 80.2707
  AND v.name = 'total_precipitation'
  AND d.name = 'ERA5';


INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-02 00:00:00',
    v.variable_id,
    0.012,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 13.0827
  AND l.longitude = 80.2707
  AND v.name = 'total_precipitation'
  AND d.name = 'ERA5';


INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-03 00:00:00',
    v.variable_id,
    0.065,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 13.0827
  AND l.longitude = 80.2707
  AND v.name = 'total_precipitation'
  AND d.name = 'ERA5';


-- ============================================================
-- 6. SAMPLE OBSERVATIONS FOR OTHER LOCATIONS
-- ============================================================

INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-02 00:00:00',
    v.variable_id,
    0.045,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 12.9249
  AND l.longitude = 80.1000
  AND v.name = 'total_precipitation'
  AND d.name = 'ERA5';


INSERT INTO weather_observations
(location_id, timestamp, variable_id, value, dataset_id)
SELECT
    l.location_id,
    '2025-10-02 00:00:00',
    v.variable_id,
    0.031,
    d.dataset_id
FROM locations l
CROSS JOIN variables v
CROSS JOIN datasets d
WHERE l.latitude = 13.1147
  AND l.longitude = 80.1098
  AND v.name = 'total_precipitation'
  AND d.name = 'ERA5';


-- ============================================================
-- END OF SAMPLE DATA
-- ============================================================