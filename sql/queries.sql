-- ============================================================
-- CLIMATE FOUNDATION MODELS
-- Climate Data Retrieval Queries
-- ============================================================


-- ============================================================
-- QUERY 1
-- TEMPORAL RETRIEVAL
--
-- Question:
-- What climate observations occurred during a specific
-- historical time period?
-- ============================================================

SELECT *
FROM weather_observations
WHERE timestamp BETWEEN
      '2025-10-01 00:00:00'
      AND
      '2025-10-03 23:59:59';


-- ============================================================
-- QUERY 2
-- VARIABLE RETRIEVAL
--
-- Question:
-- Retrieve all precipitation observations.
-- ============================================================

SELECT
    wo.observation_id,
    wo.timestamp,
    wo.value,
    v.name AS variable,
    v.unit
FROM weather_observations wo
JOIN variables v
    ON wo.variable_id = v.variable_id
WHERE v.name = 'total_precipitation';


-- ============================================================
-- QUERY 3
-- DATASET-AWARE RETRIEVAL
--
-- Question:
-- Which dataset produced each climate observation?
-- ============================================================

SELECT
    wo.timestamp,
    wo.value,
    v.name AS variable,
    d.name AS dataset,
    d.source
FROM weather_observations wo

JOIN variables v
    ON wo.variable_id = v.variable_id

JOIN datasets d
    ON wo.dataset_id = d.dataset_id

ORDER BY wo.timestamp;


-- ============================================================
-- QUERY 4
-- SPATIAL RETRIEVAL
--
-- Question:
-- Which observations were recorded within 25 km of Chennai?
--
-- Chennai:
-- Latitude  = 13.0827
-- Longitude = 80.2707
-- ============================================================

SELECT
    wo.observation_id,
    wo.timestamp,
    wo.value,
    v.name AS variable,
    l.latitude,
    l.longitude

FROM weather_observations wo

JOIN locations l
    ON wo.location_id = l.location_id

JOIN variables v
    ON wo.variable_id = v.variable_id

WHERE ST_DWithin(
    l.geography,
    ST_SetSRID(
        ST_Point(80.2707, 13.0827),
        4326
    )::geography,
    25000
);


-- ============================================================
-- QUERY 5
-- EXTREME RAINFALL RETRIEVAL
--
-- Question:
-- Find heavy precipitation observations near Chennai.
--
-- 0.05 metres = 50 mm
-- ============================================================

SELECT
    wo.timestamp,
    wo.value AS precipitation_m,
    wo.value * 1000 AS precipitation_mm,
    l.latitude,
    l.longitude

FROM weather_observations wo

JOIN locations l
    ON wo.location_id = l.location_id

JOIN variables v
    ON wo.variable_id = v.variable_id

WHERE v.name = 'total_precipitation'

  AND wo.value > 0.05

  AND ST_DWithin(
      l.geography,
      ST_SetSRID(
          ST_Point(80.2707, 13.0827),
          4326
      )::geography,
      25000
  )

ORDER BY wo.timestamp;


-- ============================================================
-- QUERY 6
-- SPATIOTEMPORAL RETRIEVAL ⭐
--
-- Question:
-- Retrieve precipitation within 25 km of Chennai
-- during October 2025.
--
-- THIS IS ONE OF THE MOST IMPORTANT QUERIES
-- FOR OUR PROJECT.
-- ============================================================

SELECT
    wo.timestamp,
    wo.value AS precipitation_m,
    wo.value * 1000 AS precipitation_mm,
    l.latitude,
    l.longitude

FROM weather_observations wo

JOIN locations l
    ON wo.location_id = l.location_id

JOIN variables v
    ON wo.variable_id = v.variable_id

WHERE v.name = 'total_precipitation'

  AND wo.timestamp BETWEEN
      '2025-10-01 00:00:00'
      AND
      '2025-10-31 23:59:59'

  AND ST_DWithin(
      l.geography,
      ST_SetSRID(
          ST_Point(80.2707, 13.0827),
          4326
      )::geography,
      25000
  )

ORDER BY wo.timestamp;


-- ============================================================
-- QUERY 7
-- NEAREST CLIMATE LOCATION
--
-- Question:
-- Which stored location is closest to Chennai?
-- ============================================================

SELECT
    location_id,
    latitude,
    longitude,
    elevation,

    ST_Distance(
        geography,
        ST_SetSRID(
            ST_Point(80.2707, 13.0827),
            4326
        )::geography
    ) AS distance_metres

FROM locations

ORDER BY geography <->
    ST_SetSRID(
        ST_Point(80.2707, 13.0827),
        4326
    )::geography

LIMIT 1;


-- ============================================================
-- QUERY 8
-- HISTORICAL CLIMATE CONTEXT
--
-- Question:
-- Retrieve temperature + precipitation conditions
-- around Chennai during a historical period.
--
-- This represents the kind of climate context that could
-- eventually be supplied to a foundation model.
-- ============================================================

SELECT
    wo.timestamp,
    l.latitude,
    l.longitude,
    v.name AS variable,
    v.unit,
    wo.value

FROM weather_observations wo

JOIN locations l
    ON wo.location_id = l.location_id

JOIN variables v
    ON wo.variable_id = v.variable_id

WHERE wo.timestamp BETWEEN
      '2025-10-01 00:00:00'
      AND
      '2025-10-03 23:59:59'

  AND v.name IN (
      '2m_temperature',
      'total_precipitation'
  )

  AND ST_DWithin(
      l.geography,
      ST_SetSRID(
          ST_Point(80.2707, 13.0827),
          4326
      )::geography,
      25000
  )

ORDER BY wo.timestamp, v.name;


-- ============================================================
-- END OF CLIMATE RETRIEVAL QUERIES
-- ============================================================