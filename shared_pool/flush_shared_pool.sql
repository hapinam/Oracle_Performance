------------------------------------------------------------------------------
-- Script    : shared_pool/flush_shared_pool.sql
-- Purpose   : Flush the entire shared pool.
-- Usage     : sqlplus / as sysdba @shared_pool/flush_shared_pool.sql
-- Requires  : SYSDBA (ALTER SYSTEM)
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
-- WARNING   : Every cursor is invalidated, so the whole workload hard parses
--             at once. This can freeze a busy production system; purge the
--             single cursor instead where possible.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Prefer shared_pool/purge_cursor.sql: it invalidates one statement instead
-- of every cursor in the instance.
ALTER SYSTEM FLUSH SHARED_POOL;
