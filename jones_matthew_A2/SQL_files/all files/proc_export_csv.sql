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
