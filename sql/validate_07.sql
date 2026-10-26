/* Checks for NULL values. Should return 0 rows. */
SELECT *
FROM prices_monthly_baseline_ratio pmbr
WHERE pmbr.price_area IS NULL
   OR pmbr.month_dk IS NULL
   OR pmbr.avg_price_eur_mwh IS NULL
   OR pmbr.baseline_price_eur_mwh IS NULL
   OR pmbr.price_to_baseline_ratio IS NULL;

/* Checks that prices_monthly_baseline_ratio has as many rows as
prices_monthly without SYSTEM, so the join dropped and duplicated
nothing. Should return 0 rows. */
SELECT (SELECT count(*)
        FROM prices_monthly_baseline_ratio) AS count_monthly_baseline_ratio,
       (SELECT count(*)
        FROM prices_monthly pm
        WHERE pm.price_area <> 'SYSTEM')    AS count_monthly
WHERE (SELECT count(*)
       FROM prices_monthly_baseline_ratio) <>
      (SELECT count(*)
       FROM prices_monthly pm
       WHERE pm.price_area <> 'SYSTEM');

/* Checks for duplicates of price area and month.
Should return 0 rows. */
SELECT pmbr.price_area,
       pmbr.month_dk,
       count(*) AS row_count
FROM prices_monthly_baseline_ratio pmbr
GROUP BY pmbr.price_area,
         pmbr.month_dk
HAVING count(*) > 1;

/* Checks that the baseline price column has the same value
on every row. Should return 0 rows. */
SELECT count(DISTINCT pmbr.baseline_price_eur_mwh) AS value_count
FROM prices_monthly_baseline_ratio pmbr
HAVING count(DISTINCT pmbr.baseline_price_eur_mwh) <> 1;