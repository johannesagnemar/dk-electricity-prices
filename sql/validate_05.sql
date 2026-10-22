/* Checks for NULL values, should return 0 rows */
SELECT *
FROM prices_yearly py
WHERE py.price_area IS NULL
   OR py.year_dk IS NULL
   OR py.avg_price_eur_mwh IS NULL
   OR py.min_price_eur_mwh IS NULL
   OR py.max_price_eur_mwh IS NULL;

/* Checks for duplicates of price area and year, should return 0 rows */
SELECT py.price_area,
       py.year_dk,
       count(*) AS row_count
FROM prices_yearly py
GROUP BY py.price_area,
         py.year_dk
HAVING count(*) > 1;

/* Checks that all years are included per price_area.
SYSTEM year count should be 11, the other price areas should be 12. */
SELECT py.price_area,
       count(*) AS year_count
FROM prices_yearly py
GROUP BY py.price_area
ORDER BY py.price_area;

/* Checks that average lies between min and max
to catch typos or swapped columns, should return 0 rows */
SELECT *
FROM prices_yearly py
WHERE py.avg_price_eur_mwh NOT BETWEEN
      py.min_price_eur_mwh AND
      py.max_price_eur_mwh;