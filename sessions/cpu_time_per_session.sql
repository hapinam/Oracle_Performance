------------------------------------------------------------------------------
-- Script    : sessions/cpu_time_per_session.sql
-- Purpose   : Rank active sessions by the CPU seconds they have consumed, to
--             find the session driving a CPU spike.
-- Usage     : sqlplus / as sysdba @sessions/cpu_time_per_session.sql
-- Requires  : SELECT_CATALOG_ROLE
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

--The CPU used by this session Oracle metric is the amount of CPU time (in 10s of milliseconds) :

select ss.sql_id,ss.machine,ss.osuser,ss.username,ss.program,ss.module,VALUE/100 cpu_usage_seconds
from v$session ss, v$sesstat se, v$statname sn
where se.STATISTIC# = sn.STATISTIC# and NAME like '%CPU used by this session%' and se.SID = ss.SID and ss.status='ACTIVE' and ss.username is not null
order by VALUE desc;
