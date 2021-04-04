set linesize 100;
set pagesize 25;
set echo on;
SET SERVEROUTPUT ON
spool "C:\School\Sem#3\Database\Scriptkiddy\preLab5.txt"

REM Prelab Lab 1

Rem task 1:

declare
v_contract_number 	CONSTANT 	NUMBER := 8;
v_client_id 	varchar(50);

begin

select client_id
into v_client_id
from ata_contract
where contract_number = v_contract_number;

exception
when no_data_found then
dbms_output.put_line('no such contract number');
		
end;
/

Rem task 2:


declare
v_contract_id 	CONSTANT 	NUMBER := 0000020;
v_contract_fee 	varchar(50);

begin

select fee
into v_contract_fee
from ata_contract
where client_id = v_contract_id;

exception
when too_many_rows then
dbms_output.put_line('client id brings back more than one fee');
		
end;
/

Rem task 3:

declare
v_add_fee 	constant number := 500;
v_event_type constant varchar(20) := 'Retirement Party';
e_wrong_event exception;

begin

update ata_contract
set fee = fee + v_add_fee
where event_type = v_event_type;

if sql%rowcount = 0 then
invoke e_wrong_event;
end if;

exception
when e_wrong_event then
dbms_output.put_line('No rows updated');

end;
/

rem task 4:

declare
v_add_fee 	constant number := 500;
v_event_type constant varchar(20) := 'Retirement Party';
e_wrong_event exception;
pragma exception_init(e_wrong_event, -20111);

begin

update ata_contract
set fee = fee + v_add_fee
where event_type = v_event_type;

if sql%rowcount = 0 then
raise_application_error(-20111, 'Wrong Event Type');
end if;

end;
/



set echo off;
spool off;

spool "C:\School\Sem#3\Database\Scriptkiddy\Lab5.txt"
set echo on;

DECLARE

-- Constant variables
  k_reduction_percentage_pres CONSTANT    NUMBER := 0.25;
  k_reduction_percentage_sal  CONSTANT    NUMBER := 0.50;  
  k_president_job             CONSTANT    VARCHAR2(15) := 'PRESIDENT';
  k_manager 				  constant    varchar2(20) := 'MANAGER';
  k_low_salary                CONSTANT    NUMBER := 100;
  k_low_sal_incr_percentage   CONSTANT    NUMBER := 0.10;
  k_commission_compare_perc	  CONSTANT	  NUMBER := 0.22;
  k_has_commission			  CONSTANT	  NUMBER := 0;

-- Local variables
  v_president_salary                      NUMBER;
  v_reduced_salary_president              NUMBER;
  v_reduced_salary_percent				  NUMBER;
  v_average_salary                        NUMBER;
  v_commission_salary					  NUMBER;
  v_increased_salary					  NUMBER;
  v_low_commission						  NUMBER;
  
  v_salary								  NUMBER;
  v_commission							  NUMBER;
  
  e_no_manager exception;
  
-- Cursor definitions

  CURSOR c_emp IS 
    SELECT * 
      FROM emp
     WHERE NVL(job, 'None') <> k_president_job;	

cursor c_managers is
select *
from emp
where job = k_manager;

BEGIN

-- Retrieve the President's salary
  SELECT sal
	INTO v_president_salary
    FROM emp
   WHERE job = k_president_job;
   
-- Retrieve the average salary of the entire company
  SELECT AVG(sal)
    INTO v_average_salary
    FROM emp;
	
  FOR r_emp IN c_emp LOOP
  
	begin
	for r_manager in c_managers loop
		if (r_emp.job = r_manager.job) then
			raise e_no_manager;
		end if;
	end loop;
	end;
  
    v_salary := r_emp.sal;
	
    IF (v_salary > v_president_salary) THEN
	
      v_reduced_salary_percent := v_salary * k_reduction_percentage_sal; 
      v_reduced_salary_president := v_president_salary * (1 - k_reduction_percentage_pres);
   
-- Which recalculated salary is less?
      IF (v_reduced_salary_percent < v_reduced_salary_president) THEN
	    v_salary := v_reduced_salary_percent;
	  ELSE
	    v_salary := v_reduced_salary_president;
	  END IF;
	END IF;

-- Is the employee's salary less than $100?	
	IF (v_salary < k_low_salary) THEN
	
	  v_increased_salary := v_salary * (1 + k_low_sal_incr_percentage);
      IF (v_increased_salary < v_average_salary) THEN
        v_salary := v_increased_salary;
      END IF;		
	END IF;

   v_commission := r_emp.comm;
   
-- Does this employee have a commission?
    IF (NVL(v_commission, k_has_commission) > k_has_commission) THEN
      v_commission_salary := v_salary * k_commission_compare_perc;

-- Is employee's commission more than 22% of their salary?
      IF (r_emp.comm > v_commission_salary) THEN
        SELECT MIN(comm)
          INTO v_low_commission
          FROM emp
         WHERE deptno = r_emp.deptno
           AND comm <> k_has_commission;
        v_commission := v_low_commission;
  	  END IF;
    END IF;
	
-- Modify the recalculated salary and commission in the database	  
    UPDATE emp
	   SET sal = v_salary,
	       comm = v_commission
	 WHERE empno = r_emp.empno;
	 
  END LOOP;
     
exception
when e_no_manager then
dbms_output.put_line('This employee has no manager');

END;
/

spool off;
set echo off;

