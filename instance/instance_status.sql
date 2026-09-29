------------------------------------------------------------------------------
-- Script    : instance/instance_status.sql
-- Purpose   : One line summary of the instance: name, version, host, startup
--             time and status.
-- Usage     : sqlplus / as sysdba @instance/instance_status.sql
-- Requires  : SELECT_CATALOG_ROLE
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

SELECT
'Oracle Instance '||INSTANCE_NAME||
' Version '||VERSION||
' on machine '||HOST_NAME||
' Started on Date '||
TO_CHAR(STARTUP_TIME,'dd-mm-yyyy "and Time "hh24:mi:ss')||
' HRS and its Database status is '||STATUS FROM V$INSTANCE
/
