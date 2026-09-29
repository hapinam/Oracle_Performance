# Creating a SQL plan baseline for a statement

Use Oracle SQL Plan Management (SPM) to capture a known-good execution plan, review it, and control whether it is enabled, accepted, or fixed.

> **Warning:** SQL plan baselines influence optimizer plan selection. Validate changes in a non-production environment first and review baselines after upgrades, statistics changes, or major data-volume changes.

## 1. Load a plan from the cursor cache

Supply the SQL ID and, when required, the plan hash value for the known-good plan.

```sql
SET SERVEROUTPUT ON

DECLARE
  l_plans_loaded PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(
    sql_id          => '&sql_id',
    plan_hash_value => &plan_hash_value
  );

  DBMS_OUTPUT.PUT_LINE('Plans loaded: ' || l_plans_loaded);
END;
/
```

## 2. Review the captured baseline

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

Display a specific baseline plan:

```sql
SELECT *
FROM TABLE(
  DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(
    sql_handle => '&sql_handle',
    plan_name  => '&plan_name',
    format     => 'BASIC'
  )
);
```

## 3. Change a baseline attribute

For example, disable a plan that should no longer be considered:

```sql
SET SERVEROUTPUT ON

DECLARE
  l_result PLS_INTEGER;
BEGIN
  l_result := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(
    sql_handle      => '&sql_handle',
    plan_name       => '&plan_name',
    attribute_name  => 'enabled',
    attribute_value => 'NO'
  );

  DBMS_OUTPUT.PUT_LINE('Plans altered: ' || l_result);
END;
/
```

After testing, a validated plan can optionally be marked as fixed:

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

## 4. Evolve a baseline

Use the evolve operation when a candidate plan needs to be evaluated through SQL Plan Management.

```sql
SET SERVEROUTPUT ON
SET LONG 10000

DECLARE
  l_report CLOB;
BEGIN
  l_report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(
    sql_handle => '&sql_handle',
    plan_name  => '&plan_name',
    verify      => 'YES',
    commit      => 'NO'
  );

  DBMS_OUTPUT.PUT_LINE(l_report);
END;
/
```

Review the evolve report before accepting any plan. Change the `COMMIT` behavior only after validating the candidate plan and understanding the effect on the workload.

## Required privileges

The account running these operations needs access to the relevant SQL Plan Management packages and dictionary views. Use an appropriately privileged administrative account and follow your environment's change-control process.

---

*Copyright (c) 2026 Mohamed Dawood. MIT Licence; see LICENSE.*
