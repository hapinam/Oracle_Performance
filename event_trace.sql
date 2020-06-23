alter system set events '10035 trace name context forever, level 1'
alter system set events '10035 trace name context off'



Check if events are enabled:
----------------------------

SET SERVEROUTPUT ON
DECLARE
    l_level NUMBER;
BEGIN
    FOR l_event IN 10035..10036
    LOOP
        dbms_system.read_ev (l_event,l_level);
        IF l_level > 0 THEN
            dbms_output.put_line ('Event '||TO_CHAR (l_event)||' is set at level '||TO_CHAR (l_level));
        END IF;
    END LOOP;
END;