------------------------------------------------------------------------------
-- Script    : shared_pool/find_sql_by_id.sql
-- Purpose   : Look up a cursor in V$SQL by SQL_ID, or find the SQL_ID a
--             session is running.
-- Usage     : sqlplus / as sysdba @shared_pool/find_sql_by_id.sql
-- Requires  : SELECT_CATALOG_ROLE
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Everything the shared pool knows about one statement.
SELECT sql_id, child_number, plan_hash_value, executions,
       elapsed_time/GREATEST(executions,1)/1000 AS ms_per_exec,
       parsing_schema_name, sql_fulltext
FROM   v$sql
WHERE  sql_id = '&&sql_id';

-- Find the SQL_ID a session is running, when you only know the OS user.
SELECT sid, serial#, username, osuser, sql_id, event, status
FROM   v$session
WHERE  osuser = '&&os_user'
AND    sql_id IS NOT NULL;

UNDEFINE sql_id
UNDEFINE os_user
