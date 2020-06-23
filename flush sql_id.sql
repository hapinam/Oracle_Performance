select ADDRESS, HASH_VALUE from V$SQLAREA where SQL_ID='5smguhfwqwkug';

ADDRESS HASH_VALUE
---------------- ------------------------
0700010FEFC27040	3111013199




exec DBMS_SHARED_POOL.PURGE ('0700010FEFC27040, 3111013199', 'C');