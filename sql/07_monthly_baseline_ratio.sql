/* Monthly average price per area divided by the 2015-2019 baseline
from prices_baseline (the same value for every area), SYSTEM excluded.
A ratio of 2 means twice the normal price. Used to colour the map in
Tableau. */
CREATE OR REPLACE TABLE prices_monthly_baseline_ratio AS
    SELECT pm.price_area,
           pm.month_dk,
           pm.avg_price_eur_mwh,
           pb.avg_price_all_areas_eur_mwh                        AS baseline_price_eur_mwh,
           pm.avg_price_eur_mwh / pb.avg_price_all_areas_eur_mwh AS price_to_baseline_ratio
    FROM prices_monthly pm
    JOIN prices_baseline pb ON pm.price_area = pb.price_area
    WHERE pm.price_area <> 'SYSTEM';

/* Export the ratio table to a CSV, sorted by month and area. */
COPY (SELECT *
      FROM prices_monthly_baseline_ratio pmbr
      ORDER BY pmbr.month_dk,
               pmbr.price_area)
TO 'output/07_monthly_baseline_ratio.csv' (HEADER);

SELECT *
      FROM prices_monthly_baseline_ratio pmbr
      ORDER BY pmbr.month_dk,
               pmbr.price_area