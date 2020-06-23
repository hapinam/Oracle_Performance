select
      extract( day from snap_interval) *24*60+
      extract( hour from snap_interval) *60+
      extract( minute from snap_interval ) "Snapshot Interval in Minutes",
      (extract( day from retention) *24*60+
      extract( hour from retention) *60+
      extract( minute from retention ))/1440 "Retention Interval in Days"
from dba_hist_wr_control;



exec DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(43200,30); -- 11520 ( 8 days by minutes)   20 minutes

execute DBMS_WORKLOAD_REPOSITORY.modify_snapshot_settings( interval => 30 );

exec dbms_workload_repository.drop_snapshot_range(255,256);
