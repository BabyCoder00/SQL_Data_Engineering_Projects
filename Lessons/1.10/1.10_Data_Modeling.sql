select 
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
from
    job_postings_fact
limit 10;

select 
    company_id,
    name
from 
    company_dim
limit 10;

select * from information_schema.tables
where table_catalog = 'data_jobs';

pragma show_tables_expanded;

describe job_postings_fact;