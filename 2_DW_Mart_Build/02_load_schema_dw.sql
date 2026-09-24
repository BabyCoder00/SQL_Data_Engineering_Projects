-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

select '=== Loading company_dim Table ===' as info;

insert into company_dim (company_id, name)
select company_id, name
from read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    auto_detect = true,
    header = true);

select '=== Loading skills_dim Table ===' as info;


insert into skills_dim (skill_id, skills, type)
select skill_id, skills, type
from read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    auto_detect = true,
    header = true);

-- Load fact table second (FK references company_dim - must load after dimensions)

select '=== Loading job_postings_fact Table ===' as info;

INSERT INTO job_postings_fact (
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT 
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', 
    AUTO_DETECT=true,
    header =true);

-- Load bridge table last (FKs reference skills_dim and job_postings_fact)
select '=== Loading skills_job_dim Table ===' as info;

INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', 
    AUTO_DETECT=true,
    header =true);


SELECT
    (SELECT COUNT(*) FROM company_dim) AS company_rows,
    (SELECT COUNT(*) FROM skills_dim) AS skill_rows,
    (SELECT COUNT(*) FROM job_postings_fact) AS job_rows,
    (SELECT COUNT(*) FROM skills_job_dim) AS job_skill_rows;

select '=== Company Dimension Sample ===' as info;
select * from company_dim limit 5;

select '=== Company Dimension Sample ===' as info;
select * from skills_dim limit 5;

select '=== Company Dimension Sample ===' as info;
select * from job_postings_fact limit 5;

select '=== Company Dimension Sample ===' as info;
select * from skills_job_dim limit 5;


