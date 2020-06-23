set autotrace traceonly;

explain plan for select * from tablename

select * from table(dbms_xplan.display);

select ID,OPERATION,OPTIONS,OBJECT_NAME,POSITION 
from plan_table;

SET LINESIZE 130
SET PAGESIZE 0

select * from table(DBMS_XPLAN.DISPLAY_CURSOR('562zj1f2mgv97'));
select * from table(DBMS_XPLAN.DISPLAY_CURSOR('94upw06rwcg44',null,'ALL'));

3h79acrqy5v2c
7fufcw4jq0z8m
562zj1f2mgv97

select * from table(dbms_xplan.display_awr('562zj1f2mgv97'));
select * from table(dbms_xplan.display_awr('94upw06rwcg44',null,null,'ALL'));

select snap_id,instance_number,sql_id,plan_hash_value,optimizer_cost,module from dba_hist_sqlstat where plan_hash_value='4175017739'

select dbms_xplan.display('PLAN_TABLE',NULL,'ADVANCED') from DUAL;


explain plan for select /*+FULL (PERF_TABLE) */ count(1) from perf_table where data_value1='ODD';
select * from table(dbms_xplan.display(format=>'ADVANCED'));



SQL>set autotrace traceonly explain 
SQL>Select * from account;


----------------


select executions,elapsed_time,round(elapsed_time/executions),plan_hash_value
from v$sql s
where sql_id='6upr12zvnsjtm'
order by last_active_time desc;


select
    sql_id "SQL_ID",plan_hash_value,    
    min(snap_id) "MIN_SNAP_ID",
    max(snap_id) "MAX_SNAP_ID",
    case when sum(executions_delta)
 = 0 then 0
    else round(sum(elapsed_time_delta)/sum(executions_delta))
    end "ElapsedPerExec(ms)",
    sum(elapsed_time_delta) "ElapsedTime (ms)",
    sum(executions_delta) "Executions"            
from dba_hist_sqlstat
where sql_id = '2upp1a4t25x99'
group by sql_id,plan_hash_value
-------------------

select 
   s.begin_interval_time, 
   s.end_interval_time , 
   q.snap_id, 
   q.dbid,    
   q.sql_id, 
   q.plan_hash_value, 
   q.optimizer_cost, 
   q.optimizer_mode 
from dba_hist_sqlstat q, dba_hist_snapshot s
where q.sql_id = '94upw06rwcg44'
and q.snap_id = s.snap_id
and s.begin_interval_time between sysdate-2 and sysdate 
order by s.snap_id desc;



select SQL_ID,plan_hash_value,TIMESTAMP,OPERATION,OBJECT_NAME,OPTIMIZER,DEPTH,POSITION,cost,cardinality,bytes,cpu_cost,io_cost,time
from V$SQL_PLAN 
where plan_hash_value='49181399' and sql_id='94upw06rwcg44'

ID   A number assigned to each step in the execution plan. 
  
PARENT_ID   The ID of the next execution step that operates on the output of the ID step. 
  
POSITION   The order of processing for steps that all have the same PARENT_ID.


-------------------------------


SELECT /*+ GATHER_PLAN_STATISTICS */ employee_id, last_name, job_id 2 FROM employees 3 WHERE job_id='AD_VP';

SQL> SELECT plan_table_output 2 FROM table(DBMS_XPLAN.DISPLAY_CURSOR (FORMAT=>'ALLSTATS LAST'));

-- For estimated rows and Actual rows