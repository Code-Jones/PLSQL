set linesize 100;
set pagesize 25;
set echo on;
spool "C:\School\Sem#3\Database\Scriptkiddy\preLab1.txt"

REM Prelab Lab 1

select * from mm_member;

INSERT INTO mm_member (member_id, last, first)
   VALUES (9, 'JJ', 'Matt');

select * from mm_member;

update mm_member set credit_card = 123456789012 where first = 'Matt';

select * from mm_member;

delete from mm_member where first = 'Matt';

select * from mm_member;

commit;

select 	rental_id "Rental ID", movie_title "Movie Title", last "Last Name"
from 	mm_movie mov 	join mm_rental r on (mov.movie_id = r.movie_id)
						join mm_member mem on (r.member_id = mem.member_id)
group by mov.movie_title, rental_id, last
order by rental_id;

select 	rental_id "Rental ID", movie_title "Movie Title", last "Last Name"
from 	mm_rental r, mm_movie mov, mm_member mem
where 	r.movie_id = mov.movie_id
and 	r.member_id = mem.member_id
group by mov.movie_title, rental_id, last
order by rental_id;

CREATE TABLE My_Table (
   My_Number 	NUMBER,
   My_Date 		Date,
   My_String	VARCHAR(5)
   );
   
insert into My_Table (My_Number, My_Date, My_String) 
values (1, sysdate, 'apple');
 
select * from My_Table;
   
drop table My_Table;

spool off;
spool "C:\School\Sem#3\Database\Scriptkiddy\Lab1.txt"

REM Lab 1

create Sequence seq_movie_id 
	start with 20
	increment by 5;
				
select * from user_sequences
where sequence_name = 'SEQ_MOVIE_ID';

SELECT seq_movie_id.NEXTVAL as Sequence
  FROM dual;

INSERT INTO mm_movie (movie_id, movie_title, movie_cat_id, movie_value, movie_qty)
  VALUES (seq_movie_id.NEXTVAL, 'Question 5', '1', 10.00, 5);
    
select * from mm_movie;

delete from mm_movie 
where movie_id = 25;

drop sequence seq_movie_id;

CREATE OR REPLACE VIEW vw_movie_rental AS
select 	rental_id "Rental ID", movie_title "Movie Title", last "Last Name"
from 	mm_movie mov 	join mm_rental r on (mov.movie_id = r.movie_id)
						join mm_member mem on (r.member_id = mem.member_id)
group by mov.movie_title, rental_id, last
order by rental_id;

select * from vw_movie_rental;

drop view vw_movie_rental;

create or replace synonym m_type
for cprg307a.mm_movie_type;

drop synonym m_type;

spool off;
set echo off;
