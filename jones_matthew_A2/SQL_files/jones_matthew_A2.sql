/* Assignment 2 Matt Jones 786524 */

set serveroutput on;

/* login in function to check permissions */

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

/* trigger to load the payroll_load table before every new entry is added */ 

create or replace trigger load_transaction_table_bir 
before insert on payroll_load
for each row

declare

v_credit 			constant        new_transactions.transaction_type%type := 'C';
v_debit 			constant        new_transactions.transaction_type%type := 'D';
payroll_good 		constant        payroll_load.status%type := 'G';
payroll_bad 		constant        payroll_load.status%type := 'B';
v_payable 			constant        new_transactions.account_no%type := 2050;
v_expense 			constant        new_transactions.account_no%type := 4045;

begin
	insert into new_transactions
	values(wkis_seq.nextval, :new.payroll_date, 'Payroll processed', v_payable, v_credit, :new.amount);
	insert into new_transactions
    values(wkis_seq.currval, :new.payroll_date, 'Payroll processed', v_expense, v_debit, :new.amount); 
	:new.status := payroll_good;
exception
	when others then
        :new.status := payroll_bad;
end;
/

/* Procedure to do the months end check of credits and expenses */


create or replace procedure proc_month_end is

equity_account_no 		constant        new_transactions.account_no%type := 5555;
credit 					constant        new_transactions.transaction_type%type := 'C';
debit 					constant        new_transactions.transaction_type%type := 'D';
revenue_type 			constant        account.account_type_code%type := 'RE';
expense_type 			constant        account.account_type_code%type := 'EX';

cursor c_exp_accounts is
select account_no, account_name, account_balance
from account
where account_type_code = expense_type;

cursor c_rev_accounts is
select account_no, account_name, account_balance
from account
where account_type_code = revenue_type;


begin
	for r_rev_accounts in c_rev_accounts loop
	
        insert into new_transactions 
		(transaction_no, transaction_date, description, account_no, transaction_type, transaction_amount)
        values 
		(wkis_seq.nextval, sysdate, 'Months End for Account ' || r_rev_accounts.account_name, 
			r_rev_accounts.account_no, debit, r_rev_accounts.account_balance); 

        insert into new_transactions 
		(transaction_no, transaction_date, description, account_no, transaction_type, transaction_amount)
        values(wkis_seq.currval, sysdate, 'Months End for Account ' || r_rev_accounts.account_name,
			equity_account_no, credit, r_rev_accounts.account_balance);
    end loop;

    for r_exp_accounts in c_exp_accounts loop

        insert into new_transactions 
		(transaction_no, transaction_date, description, account_no, transaction_type, transaction_amount)
        values
		(wkis_seq.nextval, sysdate, 'Months End for Account ' || r_exp_accounts.account_name, 
			r_exp_accounts.account_no, credit, r_exp_accounts.account_balance);

        insert into new_transactions 
		(transaction_no, transaction_date, description, account_no, transaction_type, transaction_amount)
        values
		(wkis_seq.currval, sysdate, 'Months End for Account ' || r_exp_accounts.account_name, 
		equity_account_no, debit, r_exp_accounts.account_balance);
    end loop;
end;
/


/* Exports the files to a csv file */


create or replace procedure proc_export_csv (location varchar2, filename varchar2) is

delimiter 		constant        char(1) := ',';
write_mode 		constant        char(1) := 'w';


file_type 					utl_file.file_type;
transaction_line 			varchar2(1024);

cursor c_new_transactions is
select *
from new_transactions;

begin
dbms_output.put_line(location||' '||filename||' '||write_mode);    
file_type :=  utl_file.fopen(location, filename, write_mode);
    for r_new_transactions in c_new_transactions loop
        transaction_line := '';
        transaction_line := transaction_line || r_new_transactions.transaction_no || delimiter;
        transaction_line := transaction_line || r_new_transactions.transaction_date || delimiter;
        transaction_line := transaction_line || r_new_transactions.description || delimiter;
        transaction_line := transaction_line || r_new_transactions.account_no || delimiter;
        transaction_line := transaction_line || r_new_transactions.transaction_type || delimiter;
        transaction_line := transaction_line || r_new_transactions.transaction_amount;
        utl_file.put_line(file_type, transaction_line);
    end loop;
utl_file.fclose(file_type);
end;
/
