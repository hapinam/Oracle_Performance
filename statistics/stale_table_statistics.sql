------------------------------------------------------------------------------
-- Script    : statistics/stale_table_statistics.sql
-- Purpose   : Find tables whose optimizer statistics are stale or missing,
--             and refresh them for one schema.
-- Usage     : sqlplus / as sysdba @statistics/stale_table_statistics.sql
-- Requires  : SELECT_CATALOG_ROLE, plus ANALYZE ANY to gather
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
-- WARNING   : Gathering statistics changes execution plans. Do it in a
--             maintenance window and be ready to restore the previous
--             statistics.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Statistics of one table: when were they last gathered, are they stale?
SELECT owner, table_name, object_type, last_analyzed, stale_stats
FROM   all_tab_statistics
WHERE  owner = UPPER('&&schema_name')
AND    table_name = UPPER('&&table_name');

-- Everything stale in the schema.
SELECT owner, table_name, last_analyzed, stale_stats
FROM   dba_tab_statistics
WHERE  owner = UPPER('&&schema_name')
AND    stale_stats = 'YES'
ORDER  BY last_analyzed NULLS FIRST;

-- Refresh only what is stale.
EXEC DBMS_STATS.gather_schema_stats(ownname => '&&schema_name', cascade => TRUE, degree => 12, options => 'GATHER STALE', method_opt => 'FOR ALL INDEXED COLUMNS');

UNDEFINE schema_name
UNDEFINE table_name
