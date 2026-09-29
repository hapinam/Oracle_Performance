------------------------------------------------------------------------------
-- Script    : statistics/gather_statistics.sql
-- Purpose   : The DBMS_STATS calls for gathering database, dictionary, fixed
--             object, schema, table and index statistics, with the options
--             that matter.
-- Usage     : sqlplus / as sysdba @statistics/gather_statistics.sql
-- Requires  : ANALYZE ANY, or SYSDBA for dictionary and fixed object
--             statistics
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
-- WARNING   : Database wide gathering is resource intensive and rewrites
--             execution plans. Statistics are restorable, but plans may
--             change immediately.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Database wide: dictionary and fixed object statistics matter after an
-- upgrade, the database call after a large data change.
EXEC DBMS_STATS.gather_database_stats(cascade => TRUE, degree => 8);
EXEC DBMS_STATS.gather_dictionary_stats(degree => 16);
EXEC DBMS_STATS.gather_fixed_objects_stats;

-- GATHER AUTO  = objects with no statistics plus stale ones
-- GATHER STALE = stale objects only
EXEC DBMS_STATS.gather_database_stats(cascade => TRUE, degree => 16, options => 'GATHER AUTO');
EXEC DBMS_STATS.gather_database_stats(cascade => TRUE, degree => 16, options => 'GATHER STALE');

-- One schema.
EXEC DBMS_STATS.gather_schema_stats(ownname => '&&schema_name', cascade => TRUE, degree => 8, options => 'GATHER AUTO', method_opt => 'FOR ALL COLUMNS');

-- One table, one partition, one index.
EXEC DBMS_STATS.gather_table_stats(ownname => '&&schema_name', tabname => '&&table_name', cascade => TRUE, degree => 16);
EXEC DBMS_STATS.gather_table_stats(ownname => '&&schema_name', tabname => '&&table_name', partname => '&&partition_name', cascade => TRUE, degree => 16);
EXEC DBMS_STATS.gather_index_stats(ownname => '&&schema_name', indname => '&&index_name', degree => 8);

-- Histogram control:
--   method_opt => 'FOR ALL INDEXED COLUMNS'            indexed columns only
--   method_opt => 'FOR ALL COLUMNS SIZE 254'           full histograms
--   estimate_percent => 100                            exact, slowest
--   estimate_percent => DBMS_STATS.auto_sample_size    recommended default

-- Freeze the statistics of a volatile object so they are not regathered.
EXEC DBMS_STATS.lock_table_stats('&&schema_name', '&&table_name');
-- EXEC DBMS_STATS.unlock_table_stats('&&schema_name', '&&table_name');

-- Statistics are versioned: roll a table back if a plan gets worse.
-- EXEC DBMS_STATS.restore_table_stats('&&schema_name', '&&table_name', SYSTIMESTAMP - 1);

-- Recompile anything invalidated by the change.
@?/rdbms/admin/utlrp.sql

UNDEFINE schema_name
UNDEFINE table_name
UNDEFINE partition_name
UNDEFINE index_name
