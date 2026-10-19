# Electricity Prices in Denmark and Neighbouring Regions 2015–2026

## How to rerun
Run commands from the repo folder.
1. Install [DuckDB](https://duckdb.org/install), version used: v1.5.6.

   `duckdb --version` should work in a new terminal.
2. Run `bash download.sh` (for Windows use Git Bash).
3. Run `duckdb data/prices.duckdb < sql/01_load.sql`, then the same for the next files in order.