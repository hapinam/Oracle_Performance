select distinct A.name DATABASE,B.machine SERVER
from V$database A, V$session B
where b.username is null
/
