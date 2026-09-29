------------------------------------------------------------------------------
-- Script    : plans/plan_hash_values.sql
-- Purpose   : Group cursors by plan hash value to spot a statement that has
--             several plans, and show the SQL behind one plan.
-- Usage     : sqlplus / as sysdba @plans/plan_hash_values.sql
-- Requires  : SELECT_CATALOG_ROLE
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

select s.plan_hash_value, count(*)
from v$sql s
where S.PARSING_SCHEMA_NAME not in ('SYS','SYSMAN','DBSNMP')
group by S.PLAN_HASH_VALUE
order by 2 desc;
--------------------------------------------------------------
--
--------------------------------------------------------------

-- Statements that have more than one plan in the shared pool are the usual
-- cause of "it was fast yesterday".
SELECT sql_id, COUNT(DISTINCT plan_hash_value) AS plans, COUNT(*) AS children
FROM   v$sql
WHERE  parsing_schema_name NOT IN ('SYS','SYSMAN','DBSNMP')
GROUP  BY sql_id
HAVING COUNT(DISTINCT plan_hash_value) > 1
ORDER  BY plans DESC;

-- Which statements use one particular plan?
SELECT sql_id, plan_hash_value, executions, sql_text
FROM   v$sqlarea
WHERE  plan_hash_value = &&plan_hash_value
ORDER  BY executions DESC;

-- The plans AWR has recorded for a statement, with their cost and timing.
SELECT snap_id, instance_number, plan_hash_value, optimizer_cost, module
FROM   dba_hist_sqlstat
WHERE  sql_id = '&&sql_id'
ORDER  BY snap_id;

UNDEFINE plan_hash_value
UNDEFINE sql_id
