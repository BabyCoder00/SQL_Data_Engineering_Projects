-- buckeet salary

select 
    job_title_short,
    salary_hour_avg,
    case
        when salary_hour_avg < 25 then 'Low'
        when salary_hour_avg < 50 then 'Medium'
        else 'High'
    end as salary_category
from job_postings_fact
where salary_hour_avg is not null
limit 10;

-- Handling nulls

select 
    job_title_short,
    salary_hour_avg,
    case
    when salary_hour_avg is null then 'Missing'
        when salary_hour_avg < 25 then 'Low'
        when salary_hour_avg < 50 then 'Medium'
        else 'High'
    end as salary_category
from job_postings_fact
limit 10;

-- Categorizing Catagorical values

select 
    job_title,
    case 
        when job_title like '%Data%' and job_title like '%Analyst%' then 'Data Analyst'
        when job_title like '%Data%' and job_title like '%Engineer%' then 'Data Engineer'
        when job_title like '%Data%' and job_title like '%Scientist%' then 'Data Scientist'
        else 'other'
    end as job_title_catogary,
    job_title_short
from job_postings_fact
order by random()
limit 20;

-- conditional aggregration

select 
    job_title_short,
    count(*) as total_posting,
    median(
        case 
            when salary_year_avg < 100_000 then salary_year_avg
        end
    ) as median_low_salary,
    median(
        case 
            when salary_year_avg >= 100_000 then salary_year_avg
        end
    ) as median_high_salary
from job_postings_fact
where salary_year_avg is not null
group by job_title_short;

-- conditional calculation 
    
with salaries as (    
    select
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        case    
            when salary_year_avg is not null then salary_year_avg
            when salary_hour_avg is not null then salary_hour_avg * 2080
        end as standardized_salary
    from job_postings_fact
    where salary_year_avg is not null or salary_hour_avg is not null)
select 
    *,
    case
        when standardized_salary is null then 'Missing' 
        when standardized_salary < 75_000 then 'Low'
        when standardized_salary < 150_000 then 'Medium'
        else 'High'
    end as salary_bucket
from salaries
limit 10;