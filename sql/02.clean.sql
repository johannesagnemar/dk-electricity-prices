/* Prices in raw_dayahead are quarter-hourly but are averaged to the hour to match raw_elspot */
CREATE OR REPLACE TABLE prices_hourly AS
    SELECT rd.PriceArea                                      AS price_area,
           date_trunc('hour', CAST(rd.TimeUTC AS TIMESTAMP)) AS hour_utc,
           date_trunc('hour', CAST(rd.TimeDK AS TIMESTAMP))  AS hour_dk,
           avg(CAST(rd.DayAheadPriceDKK AS DOUBLE))          AS price_dkk_mwh,
           avg(CAST(rd.DayAheadPriceEUR AS DOUBLE))          AS price_eur_mwh
    FROM raw_dayahead rd
    GROUP BY rd.PriceArea,
             date_trunc('hour', CAST(rd.TimeUTC AS TIMESTAMP)),
             date_trunc('hour', CAST(rd.TimeDK AS TIMESTAMP))

    UNION ALL

    SELECT re.PriceArea                    AS price_area,
           CAST(re.HourUTC AS TIMESTAMP)   AS hour_utc,
           CAST(re.HourDK AS TIMESTAMP)    AS hour_dk,
           CAST(re.SpotPriceDKK AS DOUBLE) AS price_dkk_mwh,
           CAST(re.SpotPriceEUR AS DOUBLE) AS price_eur_mwh
    FROM raw_elspot re;