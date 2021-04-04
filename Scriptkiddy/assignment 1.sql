column description format a30 heading "desc"
column transaction_no format 999 heading "num"
column account_no format 9999 heading "acc_no"
column transaction_amount format 999999 heading "amount"

declare

cursor new_trans is 
select *
from new_transactions
order by transaction_no asc;

cursor c_bare is 
select transaction_no, transaction_date, description
from new_transactions
group by transaction_no, transaction_date, description
order by transaction_no asc;


v_trans_no 		new_transactions.transaction_no%type;
v_acc_no 		new_transactions.account_no%type;
v_type  		new_transactions.transaction_type%type;
v_amount 		new_transactions.transaction_amount%type;
l_row 			new_transactions%rowtype;


begin

	for i_bare in c_bare loop
	
		insert into transaction_history (transaction_no, transaction_date, description)
		values (i_bare.transaction_no, i_bare.transaction_date, i_bare.description);
		
		for i_new_trans in new_trans loop
		
			if (i_new_trans.transaction_no = i_bare.transaction_no) then
				DBMS_OUTPUT.PUT_LINE(i_new_trans.transaction_no || ' : ' || i_new_trans.account_no || ' : ' || i_new_trans.transaction_type || ' : ' || i_new_trans.transaction_amount);
			end if;	
		
			if (v_trans_no is null) then
			select account_no, transaction_no, transaction_type, transaction_amount
			into v_acc_no, v_trans_no, v_type, v_amount
			from new_transactions
			where transaction_no = i_new_trans.transaction_no;
			
			insert into transaction_detail (account_no, transaction_no, transaction_type, transaction_amount)
			values (v_acc_no, v_trans_no, v_type, v_amount);
			
			else 
				 v_acc_no := null;
				 v_trans_no := null;
				 v_type := null;
				 v_amount := null;
			end if;
			
			
			
				
			
		
		end loop;
	
  end loop;

end;
/



/*

insert into transaction_detail (account_no, transaction_no, transaction_type, transaction_amount)
		values (i_all.account_no, i_all.transaction_no, i_all.transaction_type, i_all.transaction_amount);

v_account_no 	new_transactions.account_no%type;
v_trans_no 		new_transactions.transaction_no%type;
v_trans_type 	new_transactions.transaction_type%type;
v_trans_amt 	new_transactions.transaction_amount%type;





select sum(transaction_amount) 
from new_transactions 
where account_no = 1250
group by account_no;

select * from new_transactions where account_no = 1250;
*/