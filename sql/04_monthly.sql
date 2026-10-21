/* hour_dk is chosen to get whole years from 2015,
price_eur_mwh is chosen because auction prices are in Euro */
CREATE OR REPLACE TABLE prices_monthly AS
    SELECT ph.price_area                                 AS price_area,
           CAST(date_trunc('month', ph.hour_dk) AS DATE) AS month_dk,
           avg(ph.price_eur_mwh)                         AS avg_price_eur_mwh,
           min(ph.price_eur_mwh)                         AS min_price_eur_mwh,
           max(ph.price_eur_mwh)                         AS max_price_eur_mwh
    FROM prices_hourly ph
    GROUP BY ph.price_area,
             CAST(date_trunc('month', ph.hour_dk) AS DATE);

/* Exports the monthly price data into a CSV in output/
, sorted so that output is the same when rerunning and easy to navigate */
COPY (SELECT *
      FROM prices_monthly pm
      ORDER BY pm.month_dk,
               pm.price_area)
TO 'output/04_monthly.csv' (HEADER);