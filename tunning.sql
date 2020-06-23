Invalid SQL profile error:

1) You can enable the ORA-13831 error stack tracing by executing below statement: 

-------------------- 
sqlplus "/as sysdba" 

alter system set max_dump_file_size=unlimited; 
alter system set events '13831 trace name errorstack level 3'; 

exit 
-------------------- 

2) You need to wait for this issue of ORA-13831 error to re-occur. 

3) Once this error is re-occurred, you can disable it by executing below statement: 

-------------------- 
sqlplus "/as sysdba" 

alter system set events '13831 trace name errorstack off'; 

exit 
-------------------- 

4) Generated trace files will be in your directory "<diagnostic_dest>/diag/rdbms/<dbname>/<instname>/trace/" and you need upload then to SR for our review. 





select * from dba_sql_plan_baselines where lower(sql_text) like 'select ps.customer_ref, ps.product_seq, ps.product_id,%subscription_ref%' -- get script from trace file

Then drop baseline of the script which causes the error:  grep ORA-13 terbm1_ora_4662.trc, vi terbm1_ora_4662.trc

CONN sys/password@dbname AS SYSDBA

SET SERVEROUTPUT ON
DECLARE
  l_plans_dropped  PLS_INTEGER;
BEGIN
  l_plans_dropped := DBMS_SPM.drop_sql_plan_baseline (
    sql_handle => 'SQL_3c46277f74c6079b',SQL_PLAN_3sjj7gxucc1wv3fa0eaed
    plan_name  => 'SQL_PLAN_3sjj7gxucc1wv631df9a3');
    
  DBMS_OUTPUT.put_line(l_plans_dropped);
END;
/




DECLARE
    l_plans_dropped  PLS_INTEGER;
BEGIN
    l_plans_dropped := DBMS_SPM.drop_sql_plan_baseline (
    sql_handle => 'SQL_6c65acfd43c276d9');
    DBMS_OUTPUT.put_line(l_plans_dropped);
END;
/



--------------------------------------------------------------------------------------------------------------------------------------------


Move execution plan from old production to new production:

Create SQL Tuning Set from EM after knowing its sql_id ( from toad )

BEGIN 
DBMS_SQLTUNE.create_stgtab_sqlset(table_name => 'BEE2_TAB', 
schema_name => 'GENEVA_ADMIN', 
tablespace_name => 'USERS'); 
END; 
/



BEGIN 
DBMS_SQLTUNE.pack_stgtab_sqlset(sqlset_name => 'SQLSET_BEE_2', 
sqlset_owner => 'GENEVA_ADMIN', 
staging_table_name => 'BEE2_TAB', 
staging_schema_owner => 'GENEVA_ADMIN'); 
END; 
/



exp geneva_admin/geneva_admin file=sts.dmp log=sts_exp.log tables=BEE2_TAB statistics=none
imp geneva_admin/geneva_admin file=sts.dmp log=sts_imp.log full=y


sqlplus geneva_admin/geneva_admin
EXEC DBMS_SQLTUNE.create_sqlset(sqlset_name => 'RBM_BEE_2');

sqlplus / as sysdba
exec dbms_sqltune.remap_stgtab_sqlset(old_sqlset_name =>'SQLSET_BEE_2',old_sqlset_owner => 'GENEVA_ADMIN', new_sqlset_name =>'RBM_BEE_2',new_sqlset_owner => 'GENEVA_ADMIN', staging_table_name =>'BEE2_TAB',staging_schema_owner => 'GENEVA_ADMIN');



BEGIN 
DBMS_SQLTUNE.unpack_stgtab_sqlset(sqlset_name => 'RBM_BEE_2', 
sqlset_owner => 'GENEVA_ADMIN', 
replace => TRUE, 
staging_table_name => 'BEE2_TAB', 
staging_schema_owner => 'GENEVA_ADMIN'); 
END; 
/

set serveroutput on
declare
my_int pls_integer;
begin
my_int := dbms_spm.load_plans_from_sqlset (sqlset_name => 'RBM_BEE_2',
sqlset_owner => 'GENEVA_ADMIN',
sql_handle => 'SQL_2ca15a467e4f21ba',
fixed => 'YES',
enabled => 'YES');
DBMS_OUTPUT.PUT_line(my_int);
end;
/



---------------------------------------------------------------------------------------------------------------------------------------

Cache contents:

drop table t1;

create table t1 as
select
   o.owner          owner,
   o.object_name    object_name,
   o.subobject_name subobject_name,
   o.object_type    object_type,
   count(distinct file# || block#)         num_blocks
from
   dba_objects  o,
   v$bh         bh
where
   o.data_object_id  = bh.objd
and
   o.owner not in ('SYS','SYSTEM')
and
   bh.status != 'free'
group by
   o.owner,
   o.object_name,
   o.subobject_name,
   o.object_type  
order by count(distinct file# || block#) desc;



-------------------------------------------------

select
   t1.owner                                          Owner,
   object_name                                       Object_Name,
   case when object_type = 'TABLE PARTITION' then 'TAB PART'
        when object_type = 'INDEX PARTITION' then 'IDX PART'
        else object_type end Object_Type,
   round(s.bytes/1024/1024/1024)   " Object size 'GB'",
   round(sum(num_blocks)/128/1024) " Cashed size 'GB " ,
   '          '||round((sum(num_blocks)/greatest(sum(blocks), .001))*100)||' %' "% of object blocks in Buffer",
   sum(num_blocks)                                    "# Cached Blocks",
   buffer_pool                                       "Buffer_Pool",
   sum(bytes)/sum(blocks)                            "Block_Size"
from
   t1,
   dba_segments s
where
   s.segment_name = t1.object_name
and
   s.owner = t1.owner
and
   s.segment_type = t1.object_type
and
   nvl(s.partition_name,'-') = nvl(t1.subobject_name,'-')
group by
   t1.owner,
   object_name,
   object_type,
   round(s.bytes/1024/1024/1024),
   buffer_pool
having
   sum(num_blocks) > 10
order by
   sum(num_blocks) desc;


----------------------------------------------------------------------------------------------------------------------------------------

Wait event on objects for statement:
select event,
        sum(time_waited),
        b.owner,
        object_name,
	round(s.bytes/1024/1024/1024) "Size GB",
        buffer_pool
from    sys.v_$active_session_history a,
        sys.dba_objects b ,
        sys.dba_segments s
where   sql_id = '6ntx7faavwvca' and   -- or module like 'BG%'
        a.current_obj# = b.object_id and
        b.object_name=s.segment_name and
        time_waited <> 0 
        group by  event,
        b.owner,
        object_name,
	round(s.bytes/1024/1024/1024),
        buffer_pool
order by 2 desc;


--------------------------------------------------------------------------------------------------------------------------------------

Keep Cache:

Select * from dba_segments where buffer_pool='KEEP';

alter table T storage(buffer_pool keep);  -- or default

alter index I storage(buffer_pool keep);  -- or default




