create or replace table jobs_mart.staging.job_posting_flat as
select 
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name as company_name
from 
    data_jobs.job_postings_fact as jpf
left join 
    data_jobs.company_dim as cd 
on
    jpf.company_id = cd.company_id;

-- ┌──────────────────────────────────────────┐
-- │                 Describe                 │
-- │                                          │
-- │ job_id                integer   not null │
-- │ company_id            integer            │
-- │ job_title_short       varchar            │
-- │ job_title             varchar            │
-- │ job_location          varchar            │
-- │ job_via               varchar            │
-- │ job_schedule_type     varchar            │
-- │ job_work_from_home    boolean            │
-- │ search_location       varchar            │
-- │ job_posted_date       timestamp          │
-- │ job_no_degree_mention boolean            │
-- │ job_health_insurance  boolean            │
-- │ job_country           varchar            │
-- │ salary_rate           varchar            │
-- │ salary_year_avg       double             │
-- │ salary_hour_avg       double             │
-- │ company_id            integer   not null │
-- │ name                  varchar            │
-- │ link                  varchar            │
-- │ link_google           varchar            │
-- │ thumbnail             varchar            │
-- └──────────────────────────────────────────┘

select count(*) 
from jobs_mart.staging.job_posting_flat;


create or replace view staging.priority_jobs_flat_view as
select 
    jpf.*
from
    staging.job_posting_flat as jpf
join 
    staging.priority_roles as r
on 
    jpf.job_title_short = r.role_name
where r.priority_lvl = 1;

select
job_title_short, 
    count(*) as job_count
from 
    staging.priority_jobs_flat_view
group by 
    job_title_short
order by
    job_count desc;

create or replace temporary table senior_jobs_flat_temp as
select 
    *
from 
    staging.priority_jobs_flat_view
where
    job_title_short = 'Senior Data Engineer';

select
    count(*)
from 
    senior_jobs_flat_temp;

select count(*) from staging.job_posting_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;

delete from staging.job_posting_flat
where job_posted_date < '2024-01-01';

truncate table staging.job_posting_flat;

-- 8:17

