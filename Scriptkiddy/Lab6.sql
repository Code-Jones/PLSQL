set linesize 100;
set pagesize 25;
set echo on;
set serveroutput on

spool "C:\School\Sem#3\Database\Scriptkiddy\Lab 6.txt"

create or replace function func_calc_hours (date_one date, date_two date) return number as

begin

return (date_two - date_one) * 24;

end;
/

create or replace function func_set_rate (event_type varchar) return number as
v_var number;

begin

case event_type
	when 'Childrens Party' then v_var := 335;
    when 'Wedding' then v_var := 300;
	when 'Concert' then v_var := 10000; 
	else v_var := 100;
end case;

return v_var;
end;
/

create or replace function func_calc_total (rate number, hours number, perday date) return number as
var varchar(10) := to_char(perday, 'day');
var_fee number;
begin
case var
	when 'MONDAY' then var_fee := 100 + (rate * hours);
    when 'FRIDAY' then var_fee := 100 + (rate * hours);
	else var_fee := rate * hours;
end case;

return var_fee;
end;
/



declare

date_one 		ata_performance.start_time%type;
date_two 		ata_performance.stop_time%type;
per_date		ata_performance.performance_date%type;
this_type 		varchar2(20);
var_total 		number;
var_hours 		number;
var_rate 		number;



begin
SELECT start_time, stop_time, performance_date
INTO date_one, date_two, per_date
FROM ata_performance
WHERE contract_number = 4;

select event_type
into this_type
from ata_contract
where contract_number = 4;

var_hours := func_calc_hours(date_one, date_two);
var_rate := func_set_rate(this_type);
var_total := func_calc_total(var_rate, var_hours, per_date);

DBMS_OUTPUT.PUT_LINE(var_total);


end;
/


spool off
set echo off;