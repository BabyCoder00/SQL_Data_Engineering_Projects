duckdb md:data_jobs

.databases

-- .read Lessons\1.21\1.21_DDL_DML_Pt1.sql(relative path)

use data_jobs;

drop database if exists jobs_mart;

create database if not exists jobs_mart;

show databases;

-- drop database if exists jobs_mart;

select 
    catalog_name, schema_name
from
    information_schema.schemata;

use jobs_mart;

create schema if not exists jobs_mart.staging;

-- drop schema if exists staging;

create table if not exists staging.preferred_roles (
    role_id integer primary key,
    role_name varchar
);

select table_catalog, table_schema, table_name
from information_schema.tables
where table_catalog = 'jobs_mart';

drop table staging.preferred_roles;

insert into staging.preferred_roles (role_id, role_name)
values
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer');

select * 
from staging.preferred_roles;

insert into staging.preferred_roles (role_id, role_name)
values
    (3, 'Software Engineer');

alter table staging.preferred_roles
add column preferred_role boolean;

-- alter table staging.preferred_roles
-- drop column preferred_role;

update staging.preferred_roles
set preferred_role = TRUE
where role_id = 1 or role_id = 2;

update staging.preferred_roles
set preferred_role = FALSE
where role_id = 3;

alter table staging.preferred_roles
rename to priority_roles;


alter table staging.priority_roles
rename column preferred_role to priority_lvl;

alter table staging.priority_roles
alter column priority_lvl type integer;

update staging.priority_roles
set priority_lvl = 3
where role_id = 3;

select *
from staging.priority_roles;



