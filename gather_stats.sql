@?/rdbms/admin/utlrp.sql
exec DBMS_STATS.GATHER_DATABASE_STATS (cascade => TRUE,DEGREE => 8);
exec DBMS_STATS.GATHER_DICTIONARY_STATS (DEGREE => 16);
exec DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;
exec DBMS_STATS.LOCK_TABLE_STATS (null,'X$KCCLH');

###schema
---------
exec dbms_stats.gather_schema_stats(ownname => 'BANK',cascade => TRUE,DEGREE => 8,options => 'GATHER AUTO',method_opt=>'FOR ALL COLUMNS');

###object
---------
EXEC DBMS_STATS.GATHER_TABLE_STATS(ownname => 'ATOMIC', tabname => 'ALL_INSTR',cascade => TRUE,DEGREE => 16);
EXEC DBMS_STATS.GATHER_TABLE_STATS(ownname => 'ATOMIC', tabname => 'FSI_D_RM_AGGR',cascade => TRUE,DEGREE => 16,method_opt=>'FOR ALL INDEXED COLUMNS size 254' ,estimate_percent => 100);
EXEC DBMS_STATS.GATHER_TABLE_STATS('ATOMIC','ALL_INSTR_hist','YM_1810',cascade => TRUE,DEGREE => 16);
EXEC DBMS_STATS.GATHER_TABLE_STATS(ownname => 'ATOMIC', tabname => 'ALL_INSTR',cascade => TRUE,DEGREE => 16);
EXEC DBMS_STATS.GATHER_INDEX_STATS(ownname => 'BANK',indname => 'I0_BKDARC',DEGREE => 8);

###database
-----------
exec DBMS_STATS.GATHER_DATABASE_STATS (cascade => TRUE,DEGREE => 16, options => 'GATHER AUTO');  -- Auto means null + stale
exec DBMS_STATS.GATHER_DATABASE_STATS (cascade => TRUE,DEGREE => 16, options => 'GATHER STALE');  -- stale only



method_opt=>'FOR ALL INDEXED COLUMNS'
method_opt=>'FOR ALL COLUMNS'
estimate_percent => 100