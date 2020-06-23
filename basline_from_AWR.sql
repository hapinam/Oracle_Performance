SQL> exec dbms_sqltune.create_sqlset(sqlset_name => '71x439rm1kp5m_sqlset',description => 'OFSA 71x439rm1kp5m');


 
--  60647	61224   6hzfmvvn7sgsw

declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(&begin_snap_id, &end_snap_id,'sql_id='||CHR(39)||'&sql_id'||CHR(39)||' and plan_hash_value=4024778179',NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('71x439rm1kp5m_sqlset', baseline_ref_cur);
end;
/




SELECT NAME,OWNER,CREATED,STATEMENT_COUNT FROM DBA_SQLSET where name='71x439rm1kp5m_sqlset';



set serveroutput on
declare
my_int pls_integer;
begin
my_int := dbms_spm.load_plans_from_sqlset (
sqlset_name => '71x439rm1kp5m_sqlset',
sqlset_owner => 'SYS',
fixed => 'YES',
enabled => 'YES');
DBMS_OUTPUT.PUT_line(my_int);
end;
/

select * from dba_sql_plan_baselines;

DECLARE
i NATURAL;
BEGIN
i := dbms_spm.alter_sql_plan_baseline('SQL_02d0cb234a300929', plan_name => 'SQL_PLAN_05n6b4d53029917d6d93b',
attribute_name => 'fixed', attribute_value => 'YES');
dbms_output.put_line(i);
END;
/


----------------------------------------------
STS:

declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(&begin_snap_id, &end_snap_id,'sql_id='||CHR(39)||'&sql_id'||CHR(39)||'',NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('6hzfmvvn7sgsw_sqlset_test', baseline_ref_cur);
end;
/

 
--  60647	61224   6hzfmvvn7sgsw

declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(&begin_snap_id, &end_snap_id,'sql_id='||CHR(39)||'&sql_id'||CHR(39)||' and plan_hash_value=1016801474',NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('6hzfmvvn7sgsw_sqlset_test', baseline_ref_cur);
end;
/


declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(&begin_snap_id, &end_snap_id,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('all_sqlset_test', baseline_ref_cur);
end;
/
