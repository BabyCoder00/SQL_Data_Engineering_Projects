select 
    table_name,
    column_name,
    data_type
from
    information_schema.columns
where 
    table_name = 'job_postings_fact';

describe job_postings_fact;

select cast('123' as integer);

select  
    cast(job_id as varchar) || '-' ||
    cast(company_id as varchar),
    cast(job_work_from_home as int),
    cast(job_posted_date as date),
    cast(salary_year_avg as decimal(10,1))
from
    job_postings_fact
where   
    salary_year_avg is not null 
limit 10;

select (3+5.4)::int;

