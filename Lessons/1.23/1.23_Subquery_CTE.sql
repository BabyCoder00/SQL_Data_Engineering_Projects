-- Subquery

select * 
from (
    select *
    from job_postings_fact
    where salary_year_avg is not null
    or salary_hour_avg is not null
) as valid_salaries 
limit 10;

-- CTE

with valid_salaries as (
    select * 
    from job_postings_fact
    where salary_year_avg is not null
    or salary_hour_avg is not null 
)
select  * from valid_salaries
limit 10;

-- Subquery in select statement

select 
    job_title_short,
    salary_year_avg,
    (
        select median(salary_year_avg)
        from job_postings_fact
    ) as market_median_salary
from job_postings_fact
where salary_year_avg is not null 
limit 10;

-- Subquery in from

select 
    job_title_short,
    median(salary_year_avg) as median_salary,
    (
        select median(salary_year_avg)
        from job_postings_fact
        where job_work_from_home = true
    ) as market_remote_median_salary
from (
    select 
    job_title_short,
    salary_year_avg
    from job_postings_fact
    where job_work_from_home = true 
) as clean_jobs
-- where salary_year_avg is not null 
group by job_title_short
limit 10;

-- Subquery in having clause

select 
    job_title_short,
    median(salary_year_avg) as median_salary,
    (
        select median(salary_year_avg)
        from job_postings_fact
        where job_work_from_home = true
    ) as market_remote_median_salary
from (
    select 
    job_title_short,
    salary_year_avg
    from job_postings_fact
    where job_work_from_home = true 
) as clean_jobs
-- where salary_year_avg is not null 
group by job_title_short
having median(salary_year_avg) > (
    select median(salary_year_avg)
    from job_postings_fact
    where job_work_from_home = true
)
limit 10;

-- CTE Example
with title_median as (
    select  job_title_short,
    job_work_from_home,
    median(salary_year_avg)::int as median_salary
    from job_postings_fact
    where job_country ='United States'
    group by 
        job_title_short,
        job_work_from_home
)
select 
    r.job_title_short,
    r.median_salary as remote_median_salary,
    o.median_salary as onsite_median_salary,
    (r.median_salary - o.median_salary) as remote_premium
from 
    title_median as r
inner join title_median as o 
on r.job_title_short = o.job_title_short
where r.job_work_from_home = true
    and o.job_work_from_home = false
order by remote_premium desc;


-- Subquery in where

select range(10);

select *
from range(3) as src(key);

select *
from range(2) as tgt(key);

select * 
from range(3) as src(key)
where exists (
    select 1
    from range(2) as tgt(key)
    where tgt.key = src.key
);

select * 
from range(3) as src(key)
where not exists (
    select 1
    from range(2) as tgt(key)
    where tgt.key = src.key
);


select * 
from job_postings_fact as tgt
where not exists (
    select 1
    from skills_job_dim as src
    where tgt.job_id = src.job_id
)
order by job_id
limit 10;