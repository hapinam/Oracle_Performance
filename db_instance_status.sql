SELECT 
'Oracle Instance '||INSTANCE_NAME||
' Version '||VERSION||
' on machine '||HOST_NAME||
' Started on Date '||
TO_CHAR(STARTUP_TIME,'dd-mm-yyyy "and Time "hh24:mi:ss')||
' HRS and its Database status is '||STATUS FROM V$INSTANCE
/


