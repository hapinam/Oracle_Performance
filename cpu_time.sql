--The CPU used by this session Oracle metric is the amount of CPU time (in 10s of milliseconds) :

select ss.sql_id,ss.machine,ss.osuser,ss.username,ss.program,ss.module,VALUE/100 cpu_usage_seconds
from v$session ss, v$sesstat se, v$statname sn
where se.STATISTIC# = sn.STATISTIC# and NAME like '%CPU used by this session%' and se.SID = ss.SID and ss.status='ACTIVE' and ss.username is not null
order by VALUE desc;