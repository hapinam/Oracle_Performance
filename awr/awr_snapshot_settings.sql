------------------------------------------------------------------------------
-- Script    : awr/awr_snapshot_settings.sql
-- Purpose   : Read the AWR snapshot interval and retention, change them, and
--             drop a range of snapshots.
-- Usage     : sqlplus / as sysdba @awr/awr_snapshot_settings.sql
-- Requires  : SYSDBA, and a Diagnostics Pack licence for AWR
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
-- WARNING   : DROP_SNAPSHOT_RANGE permanently deletes AWR history, so past
--             performance can no longer be compared.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Current snapshot interval and retention.
SELECT EXTRACT(DAY  FROM snap_interval)*24*60
     + EXTRACT(HOUR FROM snap_interval)*60
     + EXTRACT(MINUTE FROM snap_interval)            AS "Interval (minutes)",
       (EXTRACT(DAY  FROM retention)*24*60
      + EXTRACT(HOUR FROM retention)*60
      + EXTRACT(MINUTE FROM retention))/1440         AS "Retention (days)"
FROM   dba_hist_wr_control;

-- Retention 30 days, snapshot every 30 minutes (both in minutes).
EXEC DBMS_WORKLOAD_REPOSITORY.modify_snapshot_settings(retention => 43200, interval => 30);

-- Take a snapshot now, for example either side of a batch run.
EXEC DBMS_WORKLOAD_REPOSITORY.create_snapshot;

-- Available snapshots, oldest first.
SELECT snap_id, begin_interval_time, end_interval_time
FROM   dba_hist_snapshot
ORDER  BY snap_id;

-- Drop a range to reclaim SYSAUX. The history in that range is lost.
-- EXEC DBMS_WORKLOAD_REPOSITORY.drop_snapshot_range(low_snap_id => &&low_snap, high_snap_id => &&high_snap);
