CREATE OR REPLACE TABLE raw_elspot AS
    SELECT *
    FROM read_csv('data/elspotprices.csv', decimal_separator=',');

CREATE OR REPLACE TABLE raw_dayahead AS
    SELECT *
    FROM read_csv('data/dayaheadprices.csv', decimal_separator=',');