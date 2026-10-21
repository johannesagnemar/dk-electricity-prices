/* Checks for NULL values, should return 0 rows */
SELECT *
FROM prices_monthly pm
WHERE pm.price_area IS NULL
   OR pm.month_dk IS NULL
   OR pm.avg_price_eur_mwh IS NULL
   OR pm.min_price_eur_mwh IS NULL
   OR pm.max_price_eur_mwh IS NULL;

/* Checks for duplicates of price area and month, should return 0 rows */
SELECT pm.price_area,
       pm.month_dk,
       count(*) AS row_count
FROM prices_monthly pm
GROUP BY pm.price_area,
         pm.month_dk
HAVING count(*) > 1;

/* For full years month_count is 12.
SYSTEM in 2025 and all price areas in 2026 are the exceptions */
SELECT pm.price_area,
       year(pm.month_dk) AS year_dk,
       count(*)          AS month_count
FROM prices_monthly pm
GROUP BY pm.price_area,
         year(pm.month_dk)
ORDER BY year(pm.month_dk),
         pm.price_area;

/* Checks that average lies between min and max
to catch typos or swapped columns, should return 0 rows */
SELECT *
FROM prices_monthly pm
WHERE pm.avg_price_eur_mwh NOT BETWEEN
      pm.min_price_eur_mwh AND
      pm.max_price_eur_mwh;