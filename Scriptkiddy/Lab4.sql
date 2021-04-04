set linesize 100;
set pagesize 25;
set echo on;
SET SERVEROUTPUT ON

spool "C:\School\Sem#3\Database\Scriptkiddy\Lab4.txt"

declare

cursor c_sal is 
select * from emp;

avg_salary 			Number(5);
president_salary 	Number(5);
min_comm 			Number(5);

begin

for r_sal in c_sal loop

	select avg(sal)
	into avg_salary
	from emp;
	
	select min(comm)
	into min_comm
	from emp
	where deptno = r_sal.deptno;

	case
		when r_sal.sal > 5000 then r_sal.sal := r_sal.sal * 0.75;
		when r_sal.sal < 100 and (r_sal.sal * 1.10) < avg_salary then r_sal.sal := r_sal.sal * 1.10;
		when r_sal.comm != null and (r_sal.sal * 0.22) < r_sal.comm then r_sal.sal := min_comm;
		else r_sal.sal := r_sal.sal;
	end case;
	
	end loop;
	
	commit;

end;
/

spool off;

