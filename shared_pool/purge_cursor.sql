------------------------------------------------------------------------------
-- Script    : shared_pool/purge_cursor.sql
-- Purpose   : Purge a single cursor from the shared pool so the next
--             execution is hard parsed, instead of flushing the whole pool.
-- Usage     : sqlplus / as sysdba @shared_pool/purge_cursor.sql
-- Requires  : SYSDBA (EXECUTE on DBMS_SHARED_POOL)
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
-- WARNING   : The next execution of that statement is hard parsed. Purging a
--             frequently executed cursor causes a short parse storm.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- 1. Get the address and hash value of the cursor to purge.
SELECT address, hash_value, sql_text
FROM   v$sqlarea
WHERE  sql_id = '&&sql_id';

-- 2. Purge that one cursor. The argument is 'address, hash_value' exactly as
--    printed above; 'C' means a cursor object.
-- EXEC DBMS_SHARED_POOL.PURGE('<address>, <hash_value>', 'C');

UNDEFINE sql_id
