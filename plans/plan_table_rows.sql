------------------------------------------------------------------------------
-- Script    : plans/plan_table_rows.sql
-- Purpose   : Read the raw rows of a stored plan for a SQL_ID, when
--             DBMS_XPLAN output is not enough.
-- Usage     : sqlplus / as sysdba @plans/plan_table_rows.sql
-- Requires  : SELECT on the plan table
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Raw plan rows for a statement, when the formatted DBMS_XPLAN output is not
-- enough. See plans/execution_plan.md for the formatted versions.
SELECT id, parent_id, operation, options, object_owner, object_name,
       cardinality, cost
FROM   plan_table
WHERE  sql_id = '&&sql_id'
ORDER  BY id;

UNDEFINE sql_id
