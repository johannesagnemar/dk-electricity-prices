# Electricity Prices in Denmark and Neighbouring Regions 2015–2026

This project collects day-ahead electricity prices from Energi Data Service (Energinet) for the Danish price areas DK1 and DK2 and the neighbouring areas Germany, NO2, SE3 and SE4, from 2015 onwards. Plain SQL in DuckDB combines the two source datasets into one hourly table and builds daily, monthly and yearly averages in EUR/MWh, so prices can be compared across areas and over time, starting with how the 2022 energy crisis hit each area. Each step has a validation file that shows what a correct result looks like.

Status: in progress. The Tableau sheets and a price map are being built, and the dashboard comes last.

## How to rerun
Run commands from the repo folder.
1. Install [DuckDB](https://duckdb.org/install), version used: v1.5.6.

   `duckdb --version` should work in a new terminal.
2. Run `bash download.sh` (for Windows use Git Bash).
3. Run `duckdb data/prices.duckdb < sql/01_load.sql`, then the same for the next files that start with a number, in order.
4. To check the data, run each `validate_NN.sql` the same way after the file with the same number, for example `validate_02.sql` after `02_clean.sql`. The comment above each query says what a correct result looks like.