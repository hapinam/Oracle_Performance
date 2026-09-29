------------------------------------------------------------------------------
-- Script    : instance/background_sessions.sql
-- Purpose   : Show the database name and the server hosting the background
--             sessions, a quick check of which node you are connected to.
-- Usage     : sqlplus / as sysdba @instance/background_sessions.sql
-- Requires  : SELECT_CATALOG_ROLE
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Sessions with no username are the background processes; this shows the
-- database and the server they are running on, which is the quickest way to
-- confirm which RAC node you reached.
SELECT DISTINCT d.name AS database_name, s.machine AS server
FROM   v$database d, v$session s
WHERE  s.username IS NULL;
