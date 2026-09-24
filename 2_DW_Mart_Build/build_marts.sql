
-- step 1: dw - create star schema
.read 01_create_tables_dw.sql

-- step 2: dw - load data from csv files into tables
.read 02_load_schema_dw.sql 


SHOW TABLES;