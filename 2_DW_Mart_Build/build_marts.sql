-- duckdb dw_marts.duckdb -c ".read build_marts.sql"

-- step 1: dw - create star schema
.read 01_create_tables_dw.sql

-- step 2: dw - load data from csv files into tables
.read 02_load_schema_dw.sql 

-- step 3: mart - create flat mart
.read 03_create_flat_mart.sql 

-- step 4: mart - create skills demand mart
.read 04_create_skills_mart.sql 

SHOW TABLES;