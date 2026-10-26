/* Checks for NULL values. Should return 0 rows. */
SELECT *
FROM prices_baseline pb
WHERE pb.price_area IS NULL
   OR pb.avg_price_eur_mwh IS NULL
   OR pb.avg_price_all_areas_eur_mwh IS NULL;

/* The combined average should equal the average of the per-area
averages, since every area has the same number of hours (checked in
validate_02). They are computed in different ways, so floating-point
error can make them differ in the last decimals (about 0.0000000000003
in a test). The tolerance 0.000000001 is far above that but still catches
a single missing hour. Should return 0 rows. */
SELECT avg(pb.avg_price_eur_mwh)           AS avg_area_averages_eur_mwh,
       avg(pb.avg_price_all_areas_eur_mwh) AS avg_price_all_areas_eur_mwh
FROM prices_baseline pb
HAVING abs(avg(pb.avg_price_eur_mwh) -
           avg(pb.avg_price_all_areas_eur_mwh)) > 0.000000001;

/* One row per area: exactly six rows (DE, DK1, DK2, NO2, SE3, SE4)
and no area twice. Should return 0 rows. */
SELECT count(*)                      AS row_count,
       count(DISTINCT pb.price_area) AS area_count
FROM prices_baseline pb
HAVING count(*) <> count(DISTINCT pb.price_area)
    OR count(*) <> 6;

/* SYSTEM must not be in the baseline. The comparison check can't catch
it, because SYSTEM would be in both averages. Should return 0 rows. */
SELECT pb.price_area
FROM prices_baseline pb
WHERE pb.price_area = 'SYSTEM';