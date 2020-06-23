select S.USERNAME,S.SCHEMANAME,s.sid,t.PIECE,s.osuser, t.sql_id, sql_text, S.LOGON_TIME,s.state,s.seconds_in_wait,S.CLIENT_INFO,S.MACHINE,S.MODULE,S.PROGRAM,S.TERMINAL,S.OSUSER, S.STATUS
from v$sqltext_with_newlines t,V$SESSION s
where t.address =s.sql_address
and t.hash_value = s.sql_hash_value
and s.status = 'ACTIVE'
and s.username <> 'SYSTEM'
and s.username <> 'SYSMAN'
order by s.sid,t.piece;