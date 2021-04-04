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