------------------------------------------------------------------------------
-- Script    : sessions/active_sql_by_session.sql
-- Purpose   : Show every active session with the SQL text and SQL_ID it is
--             running, plus the OS user, machine and program behind it.
-- Usage     : sqlplus / as sysdba @sessions/active_sql_by_session.sql
-- Requires  : SELECT_CATALOG_ROLE
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

select S.USERNAME,S.SCHEMANAME,s.sid,t.PIECE,s.osuser, t.sql_id, sql_text, S.LOGON_TIME,s.state,s.seconds_in_wait,S.CLIENT_INFO,S.MACHINE,S.MODULE,S.PROGRAM,S.TERMINAL,S.OSUSER, S.STATUS
from v$sqltext_with_newlines t,V$SESSION s
where t.address =s.sql_address
and t.hash_value = s.sql_hash_value
and s.status = 'ACTIVE'
and s.username <> 'SYSTEM'
and s.username <> 'SYSMAN'
order by s.sid,t.piece;
