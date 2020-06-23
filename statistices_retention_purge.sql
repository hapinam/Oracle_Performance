See the oldest statistics history available:
--------------------------------------------
SQL> SELECT DBMS_STATS.GET_STATS_HISTORY_AVAILABILITY FROM DUAL;



See the stats retention ( days ):
---------------------------------
SQL> select dbms_stats.get_stats_history_retention from dual;


Modify retention:
-----------------
SQL> exec DBMS_STATS.ALTER_STATS_HISTORY_RETENTION(60);




Space currently used to store statistics in SYSAUX in KBytes, so increasing the retention would affect it’s size:
----------------------------------------------------------------------------------------------------------------
SQL> select occupant_desc, space_usage_kbytes from v$sysaux_occupants where OCCUPANT_DESC like '%Statistics%';




Purge stats:
-----------
SQL> exec DBMS_STATS.PURGE_STATS(SYSDATE-8);



Purge Snapshots:
----------------
SQl> exec dbms_workload_repository.drop_snapshot_range(low_snap_id => 2747, high_snap_id=>2864);


Purge all:
---------




------------------------------------------------------

select occupant_desc, space_usage_kbytes/1024 MB
from v$sysaux_occupants
where space_usage_kbytes > 0
order by space_usage_kbytes;


SELECT TASK_NAME, COUNT(*) CNT FROM DBA_ADVISOR_OBJECTS GROUP BY TASK_NAME ORDER BY CNT DESC;



-------------------------------------------------------------------------------------------------------------------

Audit:
------

https://easyoradba.com/2016/09/28/sysaux-tablespace-growing-rapidly-in-oracle-12c-unified-audit-trail-audsys/



select unified_audit_policies,action_name,count(*) from unified_audit_trail group by unified_audit_policies,action_name;

exec dbms_audit_mgmt.set_last_archive_timestamp(audit_trail_type=>dbms_audit_mgmt.audit_trail_unified,last_archive_time=>sysdate-1);

exec dbms_audit_mgmt.clean_audit_trail(audit_trail_type=>dbms_audit_mgmt.audit_trail_unified,use_last_arch_timestamp=TRUE);








1. First set the Date, starting from where you need to have the Unified Auditing Records

BEGIN
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
last_archive_time => TO_TIMESTAMP('17-SEP-2018 00:00:10.0','DD-MON-RRRR HH24:MI:SS.FF'),
rac_instance_number => 2);
END;
/
2. Since Unified Auditing caches the audit trail in memory to implement a 'lazy write' feature that helps performance, some of the records eligible for deletion may still linger in the cache, to also first flush this cache

BEGIN
DBMS_AUDIT_MGMT.FLUSH_UNIFIED_AUDIT_TRAIL;
END;
/

3. Execute the Purge Procedure

BEGIN
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
use_last_arch_timestamp => TRUE);
END;
/