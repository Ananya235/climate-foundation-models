-- Example climate-data queries

-- 1. Retrieve observations for a particular time period
SELECT *
FROM weather_observations
WHERE timestamp BETWEEN '2025-10-01' AND '2025-12-31';


-- 2. Find observations associated with a particular variable
SELECT *
FROM weather_observations wo
JOIN variables v
    ON wo.variable_id = v.variable_id
WHERE v.name = 'precipitation';


-- 3. Retrieve observations near a target location
-- Example: Chennai
SELECT
    wo.*,
    l.latitude,
    l.longitude
FROM weather_observations wo
JOIN locations l
    ON wo.location_id = l.location_id
WHERE ST_DWithin(
    l.geometry::geography,
    ST_SetSRID(ST_Point(80.2707, 13.0827), 4326)::geography,
    25000
);


-- 4. Retrieve extreme rainfall observations
SELECT *
FROM weather_observations wo
JOIN variables v
    ON wo.variable_id = v.variable_id
WHERE v.name = 'precipitation'
  AND wo.value > 50;