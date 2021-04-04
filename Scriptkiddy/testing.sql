REM Testing

/* table names + column names
 */

/*(single-row functions
lower(), upper(), initcap(), concat(), substr(), length(), instr(), lpad(), rpad() 
trim(), replace(), translate(), abs(), round(), trunc(), mod(), sysdate, months_between(), add_months(),
next_day(), last_day(), to_date(), current_date(), nvl(), nvl2(), nullif(), coalesce(), decode()
to_number(), )*/

/*(multi-row functions + grouping sets
sum(), max(), min(), avg(), count(), greatest(), least(), stddev(), variance(),) 
(grouping sets
group by grouping sets (c1, c2, (c1, c2), ())
group by cube (c1, c2)
group by rollup (c1, c2)

// deal with duplicates:
select name, to_char(orderdate, 'MM-YYYY') Mth, category, count(*), group_id()
from publisher join books using (pubid) join orderitems using (isbn)
  join orders using (order#)
group by rollup (name, (to_char(orderdate, 'MM-YYYY'), category))
HAVING group_id() = 0
order by name, 2,3;
) 

(case colname
	when value1 then return1
	else returnDefault
end "alias") */

/*(Reporting
set linesize 99
set pagesize 50
set newpage 1

ttile "titles" skip 1 center
btitle left sysdate -
right 'page: ' format 99 sql.pno skip 1 -
center ''
column colname heading "words" format A20
column number heading"numbers|more numbers" format $990.99
repheader 'report title' skip 2
repfooter 'last page of report' skip 3

// only one break at a time
break on colname skip 2 on report 
break on "colname" skip 1 on report on row skip 1

compute sum label "this is it" of numbers on "othertitle"
compute count label "what it's called" of "colname" on report
//
COMPUTE {group function} OF {column_name | column_alias,. . .} 
						ON {break_column_name | ROW | PAGE | REPORT};
ttitle off
btitle off
repheader off
repfooter off
clear columns
clear compute
clear break
) */

