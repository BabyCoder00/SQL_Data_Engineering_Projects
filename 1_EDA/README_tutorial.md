# Heading 1
## Heafing 2
### Heading 3

Normal text

**Bold Text**

*Italics Text*

`This is Code`

- Bullet 1

1. Number 1

[Link Text](https://google.com)

![Alt Text](https://github.com/lukebarousse/SQL_Data_Engineering_Course/blob/main/Resources/images/1_1_Project1_EDA.png?raw=true)

```sql
select
    sd.skills,
    round(median(jpf.salary_year_avg),0) as median_salary,
    count(jpf.*) as demand_count,
    round(ln(count(jpf.*)),1) as ln_demand_count,
    round((median(jpf.salary_year_avg) * ln(count(jpf.*))) / 1_000_000, 2) as optimal_score
from job_postings_fact as jpf
inner join skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
inner join skills_dim as sd
    on sjd.skill_id = sd.skill_id
where
    jpf.job_title_short = 'Data Engineer'
    and jpf.job_work_from_home = True
    and jpf.salary_year_avg is not null
group by
    sd.skills
having 
    count(jpf.*) > 100
order by 
    median_salary desc 
limit 25;
```
-- testhf
