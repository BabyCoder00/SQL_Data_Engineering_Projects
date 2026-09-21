-- count rows - aggregation onnly

select count(*)
from 
    job_postings_fact;

-- count rows - window function

select 
    job_id,
    count(*) over()
from 
    job_postings_fact;

select
    job_id,
    job_title_short,
    salary_hour_avg,
    rank() over(
        order by salary_hour_avg desc
    )
from job_postings_fact
where
    salary_hour_avg is not null
order by 
    salary_hour_avg desc
limit 10;

select
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    avg(salary_hour_avg) over(
        partition by job_title_short, company_id
    )
from job_postings_fact
where
    salary_hour_avg is not null
order by random()
limit 10;

select
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    avg(salary_hour_avg) over(
        partition by job_title_short
        order by job_posted_date
    ) as running_avg_hour_salary
from job_postings_fact
where
    salary_hour_avg is not null and 
    job_title_short = 'Data Engineer'
order by 
    job_title_short,
    job_posted_date
limit 10;

select
    job_id,
    job_title_short,
    salary_hour_avg,
    rank() over(
        partition by job_title_short
        order by salary_hour_avg desc
    ) as rank_hourly_salary
from 
    job_postings_fact
where
    salary_hour_avg is not null --and 
    -- job_title_short = 'Data Engineer'
order by 
    salary_hour_avg desc,
    job_title_short
limit 10;

select
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    sum(salary_hour_avg) over(
        partition by job_title_short
        order by job_posted_date
    ) as running_sum_hour_salary
from job_postings_fact
where
    salary_hour_avg is not null and 
    job_title_short = 'Data Engineer'
order by 
    job_title_short,
    job_posted_date
limit 10;


select
    job_id,
    job_title_short,
    salary_hour_avg,
    dense_rank() over(
        order by salary_hour_avg desc
    )
from job_postings_fact
where
    salary_hour_avg is not null
order by 
    salary_hour_avg desc
limit 140;

-- row_number - providing a new job_id

select 
    *,
    row_number() over(
        order by job_posted_date
    ) as row_id
from 
    job_postings_fact
order by 
    job_posted_date,
    row_id
limit 20;

-- lag() - time based comaparision of company yearly salary

select 
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    lag(salary_year_avg) over(
        partition by company_id
        order by job_posted_date
    ) as previous_posting_salary,
    salary_year_avg - lag(salary_year_avg) over(
        partition by company_id
        order by job_posted_date
    ) as salary_change
    from 
        job_postings_fact
    where salary_year_avg is not null
    order by 
        company_id,
        job_posted_date
    limit 60;
