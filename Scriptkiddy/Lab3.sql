set linesize 100;
set pagesize 25;
set echo on;
SET SERVEROUTPUT ON

spool "C:\School\Sem#3\Database\Scriptkiddy\preLab3.txt"

REM Prelab Lab 3

REM Task 1

DECLARE
v_hiredate 	Date;
v_surname 	Varchar2(30);
v_firstname Varchar2(30);
k_salary 	Number(5,2);
  
BEGIN
v_hiredate 	:= TO_DATE('Jan 10, 2013', 'Mon dd, yyyy');
v_surname 	:= 'Jones';
v_firstname := 'Matt';
k_salary 	:= 100.25;

DBMS_OUTPUT.PUT_LINE(v_hiredate);
DBMS_OUTPUT.PUT_LINE(v_surname);
DBMS_OUTPUT.PUT_LINE(v_firstname);
DBMS_OUTPUT.PUT_LINE(k_salary);
  
END;
/

REM Task 2

DECLARE
v_agent_id 		varchar(7);
v_last_name 	varchar(25);
v_first_name 	varchar(25);
v_date_of_hire 	date;
v_home_phone 	varchar(10);
v_business_phone varchar(10);
  
BEGIN
select agent_id, last_name, first_name, date_of_hire, home_phone, business_phone
into v_agent_id, v_last_name, v_first_name, v_date_of_hire, v_home_phone, v_business_phone
from ata_agent
where agent_id = 0000002;


DBMS_OUTPUT.PUT_LINE(
v_first_name || ' ' || v_last_name || ' was hired on ' || 
v_date_of_hire || ' where he was given the id of ' || v_agent_id || 
'. His contact details are as follows HP: ' || v_home_phone || ' BP: ' || v_business_phone);
  
END;
/

Rem task 3

DECLARE
v_agent_id 		ata_agent.agent_id%type;
v_last_name 	ata_agent.last_name%type;
v_first_name 	ata_agent.first_name%type;
v_date_of_hire 	ata_agent.date_of_hire%type;
v_home_phone 	ata_agent.home_phone%type;
v_business_phone ata_agent.business_phone%type;
  
BEGIN
select agent_id, last_name, first_name, date_of_hire, home_phone, business_phone
into v_agent_id, v_last_name, v_first_name, v_date_of_hire, v_home_phone, v_business_phone
from ata_agent
where agent_id = 0000002;


DBMS_OUTPUT.PUT_LINE(
v_first_name || ' ' || v_last_name || ' was hired on ' || 
v_date_of_hire || ' where he was given the id of ' || v_agent_id || 
'. His contact details are as follows HP: ' || v_home_phone || ' BP: ' || v_business_phone);
  
END;
/

Rem task 4

DECLARE
  TYPE v_record IS RECORD (
    agent_id 		ata_agent.agent_id%type,
	last_name 	ata_agent.last_name%type,
	first_name 	ata_agent.first_name%type,
	date_of_hire 	ata_agent.date_of_hire%type,
	home_phone 	ata_agent.home_phone%type,
	business_phone ata_agent.business_phone%type);
v_agent  v_record;	
	
BEGIN
select agent_id, last_name, first_name, date_of_hire, home_phone, business_phone
into v_agent.agent_id, v_agent.last_name, v_agent.first_name, v_agent.date_of_hire, v_agent.home_phone, v_agent.business_phone
from ata_agent
where agent_id = 0000002;

DBMS_OUTPUT.PUT_LINE(
v_agent.first_name || ' ' || v_agent.last_name || ' was hired on ' || 
v_agent.date_of_hire || ' where he was given the id of ' || v_agent.agent_id || 
'. His contact details are as follows HP: ' || v_agent.home_phone || ' BP: ' || v_agent.business_phone);

 END;
 /
 
 Rem task 5
 
 
DECLARE
v_agent  ata_agent%ROWTYPE;	
	
BEGIN
select agent_id, last_name, first_name, date_of_hire, home_phone, business_phone
into v_agent.agent_id, v_agent.last_name, v_agent.first_name, v_agent.date_of_hire, v_agent.home_phone, v_agent.business_phone
from ata_agent
where agent_id = 0000002;

DBMS_OUTPUT.PUT_LINE(
v_agent.first_name || ' ' || v_agent.last_name || ' was hired on ' || 
v_agent.date_of_hire || ' where he was given the id of ' || v_agent.agent_id || 
'. His contact details are as follows HP: ' || v_agent.home_phone || ' BP: ' || v_agent.business_phone);

 END;
 /


spool off;

spool "C:\School\Sem#3\Database\Scriptkiddy\Lab3.txt"

REM Lab 3

select *
from emp;

declare
first_avg_salary 	Number(5);
last_avg_salary 	Number(5);
  
begin
select avg(sal)
into first_avg_salary
from emp;

update emp
set sal = (sal * 0.75)
where sal > 5000;

update emp
set sal = (sal * 1.10)
where sal < 100 and first_avg_salary >= (select avg(sal)
										from emp);
										

										
select avg(sal)
into last_avg_salary
from emp;

DBMS_OUTPUT.PUT_LINE('First Average Salary : ' || first_avg_salary);
DBMS_OUTPUT.PUT_LINE('Last Average Salary : ' || last_avg_salary);

end;
/

select *
from emp;

spool off;
echo off;

