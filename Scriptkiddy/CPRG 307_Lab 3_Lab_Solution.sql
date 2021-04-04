
DECLARE

-- Constant variables
  k_reduction_percentage      CONSTANT    NUMBER := 0.25;
  k_president_job             CONSTANT    VARCHAR2(15) := 'PRESIDENT';
  k_low_salary                CONSTANT    NUMBER := 100;
  k_low_sal_incr_percentage   CONSTANT    NUMBER := 0.10;

-- Local variables
  v_president_salary                      NUMBER;
  v_reduced_salary                        NUMBER;
  v_average_salary                        NUMBER;

BEGIN

-- Retrieve the President's salary
  SELECT sal
    INTO v_president_salary
    FROM emp
   WHERE job = k_president_job;
   
-- Calculate what a reduced salary would look like   
   v_reduced_salary := v_president_salary * (1 - k_reduction_percentage);

-- Reduce the salary of employees who make more than the President   
   UPDATE emp
      SET sal = v_reduced_salary
    WHERE sal > v_president_salary;
 
-- Retrieve the average salary of the entire company
  SELECT AVG(sal)
    INTO v_average_salary
    FROM emp;

-- Increase an employee's salary if < $100 and still lower
-- than the company average
  UPDATE emp
     SET sal = sal * (1 + k_low_sal_incr_percentage)
   WHERE sal < k_low_salary
     AND (sal * (1 + k_low_sal_incr_percentage)) < v_average_salary;   
    
-- Save changes
  COMMIT;   



END;
/

