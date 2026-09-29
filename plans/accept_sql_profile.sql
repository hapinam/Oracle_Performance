------------------------------------------------------------------------------
-- Script    : plans/accept_sql_profile.sql
-- Purpose   : Accept the SQL profile produced by a SQL Tuning Advisor task so
--             the new plan is used.
-- Usage     : sqlplus / as sysdba @plans/accept_sql_profile.sql
-- Requires  : ADMINISTER SQL MANAGEMENT OBJECT, and a Tuning Pack licence
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
-- WARNING   : FORCE_MATCH applies the profile to every statement that differs
--             only in its literals. Confirm that is what you want before
--             accepting.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- 1. Which tuning tasks have produced a recommendation?
SELECT task_name, status, execution_end
FROM   dba_advisor_tasks
WHERE  advisor_name = 'SQL Tuning Advisor'
ORDER  BY execution_end DESC;

-- 2. Read the recommendation before accepting it.
SELECT DBMS_SQLTUNE.report_tuning_task('&&task_name') FROM dual;

-- 3. Accept the profile. FORCE_MATCH makes it apply to the same statement
--    with different literal values.
EXEC DBMS_SQLTUNE.accept_sql_profile(task_name => '&&task_name', replace => TRUE, force_match => TRUE);

-- 4. Confirm it is there, and disable it if the plan turns out worse.
SELECT name, sql_text, status, force_matching FROM dba_sql_profiles;
-- EXEC DBMS_SQLTUNE.alter_sql_profile('<profile_name>', 'STATUS', 'DISABLED');

UNDEFINE task_name
