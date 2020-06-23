Assign good plan to another sql statement:

begin
dbms_output.put_line(
dbms_spm.alter_sql_plan_baseline
( sql_handle =>'SQL_e045c243c3d0182c',
attribute_name => 'enabled',
attribute_value => 'NO' ));
end;




set autotrace off
begin
dbms_output.put_line(
dbms_spm.load_plans_from_cursor_cache
( sql_id => '4jvu7df0qgbnw', -- sql_id for the good statement and plan for the good plan
plan_hash_value => 1955624545,sql_handle => 'SQL_e045c243c3d0182c')); -- sql_handle for the bad statement
end;

begin
dbms_output.put_line(
dbms_spm.load_plans_from_cursor_cache
(plan_hash_value => 1342926912,sql_handle => 'SQL_42c640c5e82e67f0')); -- sql_handle for the bad statement
end;


 



---------------------

Create baseline for a statement:


SQL> DECLARE i NATURAL;
BEGIN
i := dbms_spm.load_plans_from_cursor_cache('6upr12zvnsjtm');  
END;
 /

PL/SQL procedure successfully completed.

SQL>



 
DECLARE 
  l_plans_loaded  PLS_INTEGER; 
BEGIN 
  l_plans_loaded := DBMS_SPM.load_plans_from_cursor_cache(sql_id => '5smguhfwqwkug', plan_hash_value => '2295303066'); 
END; 
/
 





select * from table(
dbms_xplan.display_sql_plan_baseline(
sql_handle=>'SQL_ee50350259da2896', plan_name => 'SQL_PLAN_fwn1p09cxna4qce4a93e9',
format=>'basic'));


DECLARE
i NATURAL;
BEGIN
i := dbms_spm.alter_sql_plan_baseline('SQL_ee50350259da2896', plan_name => 'SQL_PLAN_fwn1p09cxna4qce4a93e9',
attribute_name => 'fixed', attribute_value => 'YES');
dbms_output.put_line(i);
END;
/


DECLARE
i NATURAL;
BEGIN
i := dbms_spm.alter_sql_plan_baseline('SQL_476f9e2e92f95eee', plan_name => 'SQL_PLAN_3c894m2ry7r9s9ddc2efb',
attribute_name => 'ACCEPTED', attribute_value => 'YES');
dbms_output.put_line(i);
END;
/
If you encounter any error when trying set the ACCEPTED parameter, please use DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE with VERIFY=>'NO' , COMMIT=>'YES in order to accept the baseline.



SQL>
SET SERVEROUTPUT ON
SET LONG 10000
DECLARE
report clob;
BEGIN
report := dbms_spm.evolve_sql_plan_baseline
('SQL_e14b5480f0df2cc7',
'SQL_PLAN_f2kunh3sdyb67ec707d83',
VERIFY=>'NO' ,
COMMIT=>'YES');
DBMS_OUTPUT.PUT_LINE(report);
END;SQL> SQL> SQL>   2    3    4    5    6    7    8    9   10
11  /
GENERAL INFORMATION
SECTION
------------------------------------------------------------------------
---------------------

Task Information:

---------------------------------------------
Task Name            : TASK_6706

Task Owner           : SYS
Execution Name       : EXEC_6478

Execution Type       : SPM EVOLVE
Scope                :
COMPREHENSIVE
Status               : COMPLETED
Started
: 09/09/2017 12:06:51
Finished             : 09/09/2017 12:06:53
Last
Updated         : 09/09/2017 12:06:53
Global Time Limit    : 2147483646

Per-Plan Time Limit  : UNUSED
Number of Errors     : 0

-------------------------------------------------------------------------------
--------------

SUMMARY
SECTION
------------------------------------------------------------------------
---------------------
  Number of plans processed  : 1
  Number of findings
: 1
  Number of recommendations  : 0
  Number of errors           : 0

-------------------------------------------------------------------------------
--------------

DETAILS
SECTION
------------------------------------------------------------------------
---------------------
Object ID          : 2

Test Plan Name     : SQL_PLAN_3c894m2ry7r9s9ddc2efb

Base Plan Name     : Cost-based plan

SQL Handle         : SQL_36212498afe3dd38

Parsing Schema     : GENEVA_ADMIN

Test Plan Creator  : SYS

SQL Text           : SELECT accr.account_num, accr.rate_event_seq,

                    NVL(accr.rating_discount_scope,0),

                    accr.discount_usage_action_dat FROM (SELECT account_num

                    FROM CUSTPRODUCTDETAILS WHERE customer_ref = :customerRef

                    AND product_seq = :productSeq AND domain_id = :domainId )

                    acc, accountrating accr WHERE accr.account_num =

                    acc.account_num AND accr.event_process_group = 1 AND

                    accr.domain_id = :domainId ORDER BY accr.account_num ASC


Bind Variables:
-----------------------------
1  -  (VARCHAR2(32)):
C4000824023
2  -  (NUMBER):
23
3  -  (NUMBER):
788144993
4  -  (NUMBER):
788144993

FINDINGS
SECTION
------------------------------------------------------------------------
---------------------

Findings (1):
-----------------------------
1. This plan
was skipped because it is already accepted.



-----------------------------------------------------------------------------
----------------

PL/SQL procedure successfully completed.


Best Regards,
---------------------------------- 
Mostafa Abd El-Mohsen | TE  | Database Administrator | Data Center Dept.
t: +20(2)31316321
e: mostafa.aboulfotouh@te.eg
K28 Cairo-Alex Desert Road,Smart Village B7 Giza , Egypt  

