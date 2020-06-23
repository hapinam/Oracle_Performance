select table_name,owner,object_type,last_analyzed,stale_stats from all_TAB_STATISTICS where upper(TABLE_name) in ('TABLE_NAME') and owner='OWNER';


select * from all_TAB_STATISTICS where stale_stats != 'NO' and owner = 'OWNER';


select table_name,owner,last_analyzed,stale_stats
from dba_tab_statistics
where owner IN ('OWNER') and stale_stats='YES';

exec dbms_stats.gather_schema_stats(ownname => 'OWNER',cascade => TRUE,DEGREE => 12,options => 'GATHER STALE',method_opt=>'FOR ALL INDEXED COLUMNS');