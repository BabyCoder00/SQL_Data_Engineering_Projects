select length('sql');

select char_length('sql');

select lower('ALL');

select upper('qwerty');

select left('sql', 2);

select right('sql', 2);

select substring('sql',2,1);

select concat('sql' || '-' || 'Functions');

select trim('  sql ');

select ltrim('   sql');

select rtrim('sql ');

select replace('sql','q','-');

select regexp_replace('data.nerd@gmail.com', '^.*(@)', '\1');

with title_lower as (
    select 
        job_title,
        lower(trim(job_title)) as job_title_clean
    from
        job_postings_fact
)
select 
    job_title,
    case 
        when job_title_clean like '%data%' and job_title_clean like '%analyst%' then 'Data Analyst'
        when job_title_clean like '%data%' and job_title_clean like '%engineer%' then 'Data Engineer'
        when job_title_clean like '%data%' and job_title_clean like '%scientist%' then 'Data Scientist'
        else 'other'
    end as job_title_catogary
from title_lower
order by random()
limit 30;

-- null functions

select nullif(10,10);

select 
    nullif(salary_year_avg,0),
    nullif(salary_hour_avg,0)
from 
    job_postings_fact
where salary_hour_avg is not null or salary_year_avg is not null
limit 10;

select coalesce(null,null,2);

select 
    salary_year_avg,
    salary_hour_avg,
    coalesce(salary_year_avg, salary_hour_avg * 2080)
from 
    job_postings_fact
where salary_hour_avg is not null or salary_year_avg is not null
limit 10;

