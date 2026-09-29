------------------------------------------------------------------------------
-- Script    : tracing/event_trace.sql
-- Purpose   : Enable and disable a numbered Oracle trace event at instance
--             level, and check which events are currently set.
-- Usage     : sqlplus / as sysdba @tracing/event_trace.sql
-- Requires  : SYSDBA (ALTER SYSTEM, EXECUTE on DBMS_SYSTEM)
-- Tested on : Oracle Database 11gR2, 12cR1 and 12cR2
-- WARNING   : Trace events are diagnostic tools that can fill the diagnostic
--             destination and slow the instance. Only enable one when Oracle
--             Support asks for it, and turn it off afterwards.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.
------------------------------------------------------------------------------

-- Enable an event at instance level (here 10035, "log parse errors").
ALTER SYSTEM SET EVENTS '10035 trace name context forever, level 1';

-- Turn it off again. Do this as soon as the diagnosis is finished.
ALTER SYSTEM SET EVENTS '10035 trace name context off';

-- Which events are currently set, and at what level?
SET SERVEROUTPUT ON
DECLARE
    l_level NUMBER;
BEGIN
    FOR l_event IN 10035..10036
    LOOP
        dbms_system.read_ev(l_event, l_level);
        IF l_level > 0 THEN
            dbms_output.put_line('Event '||TO_CHAR(l_event)
                                 ||' is set at level '||TO_CHAR(l_level));
        END IF;
    END LOOP;
END;
/

-- Trace files are written to <diagnostic_dest>/diag/rdbms/<dbname>/<instance>/trace.
SHOW PARAMETER diagnostic_dest
