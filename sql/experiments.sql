-- ============================================================
-- CLIMATE FOUNDATION MODELS
-- DBMS PERFORMANCE EXPERIMENTS
-- ============================================================


-- ============================================================
-- EXPERIMENT 1
-- TEMPORAL RETRIEVAL WITHOUT INDEX
--
-- We temporarily disable index scans so that PostgreSQL
-- performs a sequential scan.
--
-- This gives us a baseline for comparison.
-- ============================================================

SET enable_indexscan = OFF;
SET enable_bitmapscan = OFF;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM weather_observations
WHERE timestamp BETWEEN
      '2025-10-01 00:00:00'
      AND
      '2025-10-31 23:59:59';


-- ============================================================
-- EXPERIMENT 1B
-- TEMPORAL RETRIEVAL WITH INDEX
-- ============================================================

RESET enable_indexscan;
RESET enable_bitmapscan;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM weather_observations
WHERE timestamp BETWEEN
      '2025-10-01 00:00:00'
      AND
      '2025-10-31 23:59:59';


-- ============================================================
-- EXPERIMENT 2
-- SPATIAL RETRIEVAL WITHOUT SPATIAL INDEX
-- ============================================================

SET enable_indexscan = OFF;
SET enable_bitmapscan = OFF;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    wo.*
FROM weather_observations wo
JOIN locations l
    ON wo.location_id = l.location_id
WHERE ST_DWithin(
    l.geography,
    ST_SetSRID(
        ST_Point(80.2707, 13.0827),
        4326
    )::geography,
    25000
);


-- ============================================================
-- EXPERIMENT 2B
-- SPATIAL RETRIEVAL WITH GiST INDEX
-- ============================================================

RESET enable_indexscan;
RESET enable_bitmapscan;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    wo.*
FROM weather_observations wo
JOIN locations l
    ON wo.location_id = l.location_id
WHERE ST_DWithin(
    l.geography,
    ST_SetSRID(
        ST_Point(80.2707, 13.0827),
        4326
    )::geography,
    25000
);


-- ============================================================
-- EXPERIMENT 3
-- SPATIOTEMPORAL RETRIEVAL
--
-- This represents our most important use case:
--
-- location + time + climate variable
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    wo.timestamp,
    wo.value,
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
  );


-- ============================================================
-- EXPERIMENT 4
-- QUERY PLAN FOR NEAREST LOCATION
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    location_id,
    latitude,
    longitude,

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
-- END OF EXPERIMENTS
-- ============================================================