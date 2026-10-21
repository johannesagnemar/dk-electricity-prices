/* Checks for NULL values, should return 0 rows */
SELECT *
FROM prices_daily pd
WHERE pd.price_area IS NULL
   OR pd.date_dk IS NULL
   OR pd.avg_price_eur_mwh IS NULL
   OR pd.min_price_eur_mwh IS NULL
   OR pd.max_price_eur_mwh IS NULL;

/* Checks for duplicates of price area and date, should return 0 rows */
SELECT pd.price_area,
       pd.date_dk,
       count(*) AS row_count
FROM prices_daily pd
GROUP BY pd.price_area,
         pd.date_dk
HAVING count(*) > 1;

/* For full normal years day_count is 365, for leap years 366.
SYSTEM in 2025 and all price areas in 2026 are the exceptions */
SELECT pd.price_area,
       year(pd.date_dk) AS year_dk,
       count(*)         AS day_count
FROM prices_daily pd
GROUP BY pd.price_area,
         year(pd.date_dk)
ORDER BY year(pd.date_dk),
         pd.price_area;

/* Checks that average lies between min and max
to catch typos or swapped columns, should return 0 rows */
SELECT *
FROM prices_daily pd
WHERE pd.avg_price_eur_mwh NOT BETWEEN
      pd.min_price_eur_mwh AND
      pd.max_price_eur_mwh;