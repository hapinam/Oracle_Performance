select s.plan_hash_value, count(*)
from v$sql s
where S.PARSING_SCHEMA_NAME not in ('SYS','SYSMAN','DBSNMP')
group by S.PLAN_HASH_VALUE
order by 2 desc;
--------------------------------------------------------------
##############################################################
--------------------------------------------------------------
select sql_text, executions
from v$sqlarea
where plan_hash_value = 354138984
order by 2 desc ;