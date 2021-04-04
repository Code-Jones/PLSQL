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