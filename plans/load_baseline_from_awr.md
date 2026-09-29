# Loading a SQL plan baseline from AWR

Capture a known-good execution plan that exists in AWR, load it into a SQL tuning set (STS), and then create a SQL plan baseline from it.

> **Warning:** SQL plan baselines influence optimizer plan selection. Setting a plan to `FIXED` gives fixed plans preference over non-fixed plans. Validate the target plan and test the change before applying it to a production workload.

## 1. Create a SQL tuning set

```sql
BEGIN
  DBMS_SQLTUNE.CREATE_SQLSET(
    sqlset_name => 'PERF_BASELINE_STS',
    description => 'AWR statements selected for baseline creation'
  );
END;
/
```

## 2. Load a known-good plan from AWR

Supply the snapshot range, SQL ID, and plan hash value when prompted.

```sql
DECLARE
  l_cursor DBMS_SQLTUNE.SQLSET_CURSOR;
BEGIN
  OPEN l_cursor FOR
    SELECT VALUE(p)
    FROM TABLE(
      DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        &begin_snap_id,
        &end_snap_id,
        'sql_id=' || CHR(39) || '&sql_id' || CHR(39) ||
        ' and plan_hash_value=&plan_hash_value',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        'ALL'
      )
    ) p;

  DBMS_SQLTUNE.LOAD_SQLSET(
    sqlset_name     => 'PERF_BASELINE_STS',
    populate_cursor => l_cursor
  );
END;
/
```

Confirm that the statement was loaded:

```sql
SELECT name,
       owner,
       created,
       statement_count
FROM   dba_sqlset
WHERE  name = 'PERF_BASELINE_STS';
```

## 3. Load plans into SQL Plan Management

Start with the plan enabled but not fixed so it can be reviewed before stronger plan-control attributes are applied.

```sql
SET SERVEROUTPUT ON

DECLARE
  l_plans_loaded PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(
    sqlset_name  => 'PERF_BASELINE_STS',
    sqlset_owner => 'SYS',
    fixed        => 'NO',
    enabled      => 'YES'
  );

  DBMS_OUTPUT.PUT_LINE('Plans loaded: ' || l_plans_loaded);
END;
/
```

Review the resulting baseline:

```sql
SELECT sql_handle,
       plan_name,
       enabled,
       accepted,
       fixed,
       created
FROM   dba_sql_plan_baselines
ORDER BY created DESC;
```

## 4. Optionally fix a validated plan

Only do this after confirming that the baseline represents the intended execution plan.

```sql
DECLARE
  l_result PLS_INTEGER;
BEGIN
  l_result := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(
    sql_handle      => '&sql_handle',
    plan_name       => '&plan_name',
    attribute_name  => 'fixed',
    attribute_value => 'YES'
  );

  DBMS_OUTPUT.PUT_LINE('Plans altered: ' || l_result);
END;
/
```

## Required privileges

Depending on the Oracle version and environment, the account running these operations needs access to the relevant AWR, SQL Tuning Advisor, SQL Plan Management packages, and dictionary views. Use an appropriately privileged administrative account and validate changes in a non-production environment first.

---

*Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.*
