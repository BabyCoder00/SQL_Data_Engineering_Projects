-- array function

select [1, 2, 3];

select ['python', 'sql', 'r'];


with skills as (
select 'python' as skill
union all
select 'sql'
union all
select 'r'
)
select array_agg(skill) skill_array
from skills;

with skills as (
select 'python' as skill
union all
select 'sql'
union all
select 'r'
), skills_array as (
select list(skill order by skill) skill_array
from skills
)
select 
    skill_array[1] as first_skill,
    skill_array[2] as second_skill,
    skill_array[3] as third_skill
from skills_array;

-- struct 

select {skill: 'python', type:'programing'} as skill_struct;

select  
    struct_pack(
        skill:= 'python',
        type:= 'programing'
    ) as skill_struct_pack;

with skill_struct as(
    select  
        struct_pack(
            skill:= 'python',
            type:= 'programing'
        ) as s
)
select 
    s.skill,
    s.type
from
    skill_struct;

with skill_table as (
    select 'python' as skill, 'programing' as type
    union all
    select 'sql', 'query_language'
    union all
    select 'r', 'programing'
)
select 
    struct_pack(
        skill:= skill,
        type := type
    )
from skill_table;

-- array of struct

select[
    {skill: 'python', type: 'programing'},
    {skill: 'sql', type: 'query_language'}
] as skills_arrray_of_struct;

with skill_table as (
    select 'python' as skill, 'programing' as type
    union all
    select 'sql', 'query_language'
    union all
    select 'r', 'programing'
), skill_array_struct as (
select
    array_agg( 
        struct_pack(
            skill:= skill,
            type := type
        ) 
    ) as array_struct
from skill_table
)
select 
    array_struct[1],
    array_struct[2],
    array_struct[3]
from skill_array_struct;

WITH skill_table AS (
    SELECT 'python' AS skill, 'programing' AS type, 1 AS sort_order
    UNION ALL
    SELECT 'sql', 'query_language', 2
    UNION ALL
    SELECT 'r', 'programing', 3
),
skill_array_struct AS (
    SELECT
        array_agg(
            struct_pack(
                skill := skill,
                type := type
            )
            ORDER BY sort_order
        ) AS array_struct
    FROM skill_table
)
SELECT
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
FROM skill_array_struct;

-- map/object/dictionary

with skill_map as (
    select map{'skill' : 'python', 'type' : 'programing'} as skill_type
)
select  
    skill_type['skill'],
    skill_type['type']
from skill_map;

-- json

with raw_skill_json as (
    select 
        '{"skill" : "python", "type" : "programing"}'::json as skill_json
)
select 
    struct_pack(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
from raw_skill_json;

-- Build a flat skill table for coworkers to access job titles, salary info, and skills in one table


create or replace temp table job_skills_array as
select 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    array_agg(sd.skills) as skills_array
from job_postings_fact as jpf
left join skills_job_dim as sjd 
    on jpf.job_id = sjd.job_id
left join skills_dim as sd 
    on sd.skill_id = sjd.skill_id
group by all;

-- From the perspective of a data analyst, analyze the median salary per skill

-- with skills as (
-- select 'python' as skill
-- union all
-- select 'sql'
-- union all
-- select 'r'
-- ), skills_array as (
-- select list(skill order by skill) skill_array
-- from skills
-- )
-- select 
--     unnest(skill_array)
-- from skills_array;

with flat_skills as (
    select 
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_array) as skill 
    from 
        job_skills_array
)
select 
    skill, 
    median(salary_year_avg) as median_salary
from flat_skills
group by all
order by median_salary desc;

-- buid a flat skill & type table for co-workers to access job_titles, salary info, skills, and type in one table

create or replace temp table job_skills_array_struct as
select 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    array_agg(
        struct_pack(
            skill_type := sd.type,
            skill_name := sd.skills 
        )
    ) as skills_type
from job_postings_fact as jpf
left join skills_job_dim as sjd 
    on jpf.job_id = sjd.job_id
left join skills_dim as sd 
    on sd.skill_id = sjd.skill_id
group by all;

-- from the prespective of a data analyst , analyze the median salary per type of skill

with flat_skills as (
    select 
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_type). skill_type as skill_type,
        unnest(skills_type). skill_name as skill_name
    from 
        job_skills_array_struct
)
select 
    skill_type,
    median(salary_year_avg) as median_salary
from flat_skills
group by all;