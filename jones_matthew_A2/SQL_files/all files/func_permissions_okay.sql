/* login in function to check permissions */


set serveroutput on;

create or replace function func_permissions_okay
return varchar2 as user_permission varchar2(2) := 'N';

begin
	select 'Y' 
		into user_permission
		from user_tab_privs
		where table_name='UTL_FILE' 
		and privilege = 'EXECUTE';
	return lv_permission;
exception
    when no_data_found then
        return user_permission;
end func_permissions_okay;
/