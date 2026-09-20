select [1,1,1,2];

select unnest([1,1,1,2])
union
select unnest([1,1,3]);

select unnest([1,1,1,2])
union all
select unnest([1,1,3]);

select unnest([1,1,1,2])
intersect
select unnest([1,1,3]);

select unnest([1,1,1,2])
intersect all
select unnest([1,1,3]);

select unnest([1,1,1,2])
except
select unnest([1,1,3]);

select unnest([1,1,1,2])
except all
select unnest([1,1,3]);

create or replace temp table jobs_2023 as
select * exclude(job_id, job_posted_date)
from job_postings_fact
where extract(year from job_posted_date) = 2023; 

create or replace temp table jobs_2024 as
select * exclude(job_id, job_posted_date)
from job_postings_fact
where extract(year from job_posted_date) = 2024;

select * from jobs_2023
limit 100;

select * from jobs_2024
limit 100;

-- which unique job posting appeared in either 2023 or 2024

select * from jobs_2023
union 
select * from jobs_2024;

select 
    'jobs_2023' as table_name,
    count(*) 
from jobs_2023
union
select
    'jobs_2024' as table_name,
    count(*) 
from jobs_2024;

-- which jobs posting appeared accross both years, counting duplicates

select * from jobs_2023
union all
select * from jobs_2024;

-- which job posting appeared in 2023 but not in 2024?

select * from jobs_2023
except
select * from jobs_2024;

-- which job posting from 2023 remain after subtracting matching 2024 posting,one by one?

select * from jobs_2023
except all
select * from jobs_2024;

-- -- which job postings apperared in both 2023 and 2024?

select * from jobs_2023
intersect
select * from jobs_2024;

-- which jobs postings appeared in both years, preserving duplicates counts?

select * from jobs_2023
intersect all
select * from jobs_2024;