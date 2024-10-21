create table  dim_empleado as (
select emp_id,emp_nm,email,education_level
from public.raw_data
group by 1,2,3,4
);


CREATE TABLE dim_departaments (
    id int AUTOINCREMENT,
    departament_name varchar   
);

INSERT INTO dim_departaments ( departament_name)
select a.DEPARTMENT
from public.raw_data a
group by 1;
            


CREATE TABLE dim_location (
    id_location int AUTOINCREMENT,
    location_name varchar   ,
    address varchar,
    city varchar,
    state varchar
);

INSERT INTO dim_location ( location_name,address,city,state)
select location,address,city , state 
from public.raw_data a
group by 1,2,3,4;


CREATE  or replace TABLE fact_employee_info (
    id int AUTOINCREMENT,
    emp_id varchar   ,
    id_departament int,
    id_location int , 
    job_title varchar,
    manager varchar,
    start_dt date,
    end_dt date
);

insert into fact_employee_info   (
emp_id,id_departament, id_location,job_title,manager,start_dt,end_dt)
select emp_id, dd.id as id_departament ,dl.id_location ,job_title,manager,start_dt,end_dt
FROM PUBLIC.RAW_DATA rd
 join public.dim_location dl on dl.location_name = rd.location
 join public.dim_departaments dd on dd.departament_name = rd.department;

CREATE  or replace TABLE dim_salary (
    id_salary int AUTOINCREMENT,
    id_fact_employee int,
    salary double 
);



insert into dim_salary (id_fact_employee , salary )
select fei.id,rd.salary
from public.raw_data rd
join public.fact_employee_info fei on fei.emp_id = rd.emp_id  and rd.start_dt = fei.start_dt;

