select 
    job_posted_date,
    job_posted_date:: date as date,
    job_posted_date::time as time,
    job_posted_date::timestamp as timestamp,
    job_posted_date::timestamptz as timestamptz
from job_postings_fact
limit 10;

select 
    job_posted_date,
    extract(year from job_posted_date) as job_posted_year,
    extract(month from job_posted_date) as job_posted_month,
    extract(day from job_posted_date) as job_posted_day
from job_postings_fact
limit 10;


select 
    extract(year from job_posted_date) as job_posted_year,
    extract(month from job_posted_date) as job_posted_month,
    count(job_id) as job_count
from job_postings_fact
where job_title_short = 'Data Engineer'
group by 
    extract(year from job_posted_date),
    extract(month from job_posted_date)
order by 
    job_posted_year,
    job_posted_month;

select 
    job_posted_date,
    date_trunc('month', job_posted_date) as job_posted_month,
    date_trunc('year', job_posted_date) as job_posted_year,
    DATE_TRUNC('day', job_posted_date) as job_posted_day
from job_postings_fact
order by random()
limit 10;

select
    date_trunc('month', job_posted_date):: date as job_posted_month,
    count(job_id) as job_count
from job_postings_fact
where 
    job_title_short = 'Data Engineer' and
    extract(year from job_posted_date) = 2024
group by 
    date_trunc('month', job_posted_date)
order by 
    job_posted_month;

select 
    '2026-01-01 00:00:00+00'::timestamptz at time zone 'ist';  

select 
    job_posted_date
from 
    job_postings_fact
limit 10;

select 
    job_posted_date at time zone 'UTC' at time zone 'IST'
from 
    job_postings_fact
limit 10;