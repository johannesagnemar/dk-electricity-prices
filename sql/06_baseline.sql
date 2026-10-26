/* Baseline prices for 2015-2019: the average hourly price per area
and for all areas combined, SYSTEM excluded. The period stops before
2020, an unusually low year. Used as the colour baseline for the map
in Tableau. */
CREATE OR REPLACE TABLE prices_baseline AS
    WITH baseline_hours AS (
        SELECT ph.price_area,
               ph.price_eur_mwh
        FROM prices_hourly ph
        WHERE year(ph.hour_dk) BETWEEN 2015 AND 2019
          /* SYSTEM is not a zone but a price calculated from the Nordic
          zones, so including it would count them twice. */
          AND ph.price_area <> 'SYSTEM'
    ),
         per_area       AS (
        SELECT bh.price_area,
               avg(bh.price_eur_mwh) AS avg_price_eur_mwh
        FROM baseline_hours bh
        GROUP BY bh.price_area
    ),
         all_areas      AS (
        SELECT avg(bh.price_eur_mwh) AS avg_price_all_areas_eur_mwh
        FROM baseline_hours bh
    )

    SELECT pa.price_area,
           pa.avg_price_eur_mwh,
           aa.avg_price_all_areas_eur_mwh
    FROM per_area pa
    /* all_areas has one row, so every area gets the same combined value. */
    CROSS JOIN all_areas aa;

/* Export the baseline to CSV, sorted by area. */
COPY (SELECT *
      FROM prices_baseline pb
      ORDER BY pb.price_area)
TO 'output/06_baseline.csv' (HEADER);