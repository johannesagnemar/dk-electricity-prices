/* Checks for NULL values, should return 0 rows */
SELECT *
FROM prices_hourly ph
WHERE ph.price_area IS NULL
   OR ph.hour_utc IS NULL
   OR ph.hour_dk IS NULL
   OR ph.price_dkk_mwh IS NULL
   OR ph.price_eur_mwh IS NULL;

/* Checks for duplicates of price area and hour, should return 0 rows */
SELECT ph.price_area,
       ph.hour_utc,
       count(*) AS row_count
FROM prices_hourly ph
GROUP BY ph.price_area,
         ph.hour_utc
HAVING count(*) > 1;

/* For full normal years hour_count is 8760, for leap years 8784.
SYSTEM in 2025 and all price areas in 2026 are the exceptions */
SELECT ph.price_area,
       year(ph.hour_dk) AS year_dk,
       count(*)         AS hour_count
FROM prices_hourly ph
GROUP BY ph.price_area,
         year(ph.hour_dk)
ORDER BY year(ph.hour_dk),
         ph.price_area;

/* Returns rows around the hours the data source shifted from Elspotprices
to DayAheadPrices. Used to check that prices are continuous */
SELECT *
FROM prices_hourly ph
WHERE ph.price_area = 'DK1'
  AND ph.hour_dk >= TIMESTAMP '2025-09-30 20:00'
  AND ph.hour_dk <  TIMESTAMP '2025-10-01 05:00'
ORDER BY ph.hour_dk;