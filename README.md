# Oracle Performance

Scripts and working notes for diagnosing and fixing Oracle Database performance
problems: finding the session or statement that is burning the machine, reading
execution plans, managing optimizer statistics, pinning good plans with SQL plan
baselines and profiles, and controlling AWR history.

## Contents

- [Requirements](#requirements)
- [How to use these scripts](#how-to-use-these-scripts)
- [Safety rules](#safety-rules)
- [Script index](#script-index)
- [Conventions](#conventions)
- [Contributing](#contributing)
- [Licence](#licence)

## Requirements

- Oracle Database 11gR2 or later. The scripts were used on 11gR2, 12cR1 and
  12cR2; most of them work unchanged on 19c.
- SQL*Plus or SQLcl. Nothing else is needed, there is no installation step.
- A privileged account. Most scripts read `V$` and `DBA_` views, so
  `SELECT_CATALOG_ROLE` is enough; the ones that change instance settings need
  `SYSDBA`. Each script states what it needs in its header.
- A **Diagnostics Pack** licence for anything touching AWR (`DBA_HIST_*`,
  `DBMS_WORKLOAD_REPOSITORY`) and a **Tuning Pack** licence for SQL profiles and
  the SQL Tuning Advisor. Querying those views on an unlicensed database is a
  licence breach, not just a technicality.

## How to use these scripts

Clone the repository and run a script from SQL*Plus:

```bash
git clone https://github.com/hapinam/Oracle_Performance.git
cd Oracle_Performance
sqlplus / as sysdba @sessions/active_sql_by_session.sql
```

Scripts prompt for what they need, so nothing is hard coded to one environment:

```sql
SQL> @statistics/stale_table_statistics.sql
Enter value for schema_name: APP_OWNER
Enter value for table_name: ORDERS
```

A typical investigation runs in this order:

1. `sessions/active_sql_by_session.sql` and `sessions/cpu_time_per_session.sql`
   to find who is active and what they are running.
2. `plans/execution_plan.md` to pull the plan for that `SQL_ID`.
3. `plans/plan_hash_values.sql` to check whether the plan changed.
4. `statistics/stale_table_statistics.sql` to see whether stale statistics
   caused the change.
5. `plans/create_baseline_for_statement.md` to pin the good plan if it did.

## Safety rules

- **Read the header first.** Every script says what it does, what privileges it
  needs, and warns when it is disruptive.
- **`shared_pool/flush_shared_pool.sql` invalidates every cursor** and makes the
  whole workload hard parse at once. On a busy production database, purge the
  single cursor instead (`shared_pool/purge_cursor.sql`).
- **Gathering statistics changes execution plans.** Do it in a maintenance
  window, and remember `DBMS_STATS.restore_table_stats` exists.
- **Baselines and profiles override the optimizer.** Review them after an
  upgrade or a large data change, or they will keep an obsolete plan alive.
- **Purging AWR or statistics history is permanent.** There is no undo, and the
  comparison you want next week is gone.
- **Nothing here should contain real credentials, hosts or schema names.** The
  examples use placeholders such as `APP_OWNER` and `<password>` on purpose.

## Script index

### AWR (`awr/`)

| Script | What it does | Caution |
| --- | --- | --- |
| [`awr_snapshot_settings.sql`](awr/awr_snapshot_settings.sql) | Read the AWR snapshot interval and retention, change them, and drop a range of snapshots. | read the warning in the header |

### Instance (`instance/`)

| Script | What it does | Caution |
| --- | --- | --- |
| [`background_sessions.sql`](instance/background_sessions.sql) | Show the database name and the server hosting the background sessions, a quick check of which node you are connected to. |  |
| [`instance_status.sql`](instance/instance_status.sql) | One line summary of the instance: name, version, host, startup time and status. |  |

### Execution plans, baselines and profiles (`plans/`)

| Script | What it does | Caution |
| --- | --- | --- |
| [`accept_sql_profile.sql`](plans/accept_sql_profile.sql) | Accept the SQL profile produced by a SQL Tuning Advisor task so the new plan is used. | read the warning in the header |
| [`create_baseline_for_statement.md`](plans/create_baseline_for_statement.md) | How to pin a good plan to a statement with DBMS_SPM, taking the plan from the cursor cache or from another statement, and how to disable the bad one. | read the warning in the header |
| [`execution_plan.md`](plans/execution_plan.md) | The ways to get an execution plan out of Oracle: EXPLAIN PLAN, DBMS_XPLAN against the cursor cache, against AWR, and with autotrace. |  |
| [`load_baseline_from_awr.md`](plans/load_baseline_from_awr.md) | How to capture a known good plan that only exists in AWR into a SQL tuning set, then load it as a SQL plan baseline. | read the warning in the header |
| [`plan_hash_values.sql`](plans/plan_hash_values.sql) | Group cursors by plan hash value to spot a statement that has several plans, and show the SQL behind one plan. |  |
| [`plan_table_rows.sql`](plans/plan_table_rows.sql) | Read the raw rows of a stored plan for a SQL_ID, when DBMS_XPLAN output is not enough. |  |
| [`sql_tuning_notes.md`](plans/sql_tuning_notes.md) | Notes collected while tuning real statements: tracing an ORA-13831, dropping a bad baseline, transporting a SQL tuning set between databases, and inspecting what is in the buffer cache. | read the warning in the header |

### Sessions (`sessions/`)

| Script | What it does | Caution |
| --- | --- | --- |
| [`active_sql_by_session.sql`](sessions/active_sql_by_session.sql) | Show every active session with the SQL text and SQL_ID it is running, plus the OS user, machine and program behind it. |  |
| [`cpu_time_per_session.sql`](sessions/cpu_time_per_session.sql) | Rank active sessions by the CPU seconds they have consumed, to find the session driving a CPU spike. |  |

### Shared pool and cursors (`shared_pool/`)

| Script | What it does | Caution |
| --- | --- | --- |
| [`find_sql_by_id.sql`](shared_pool/find_sql_by_id.sql) | Look up a cursor in V$SQL by SQL_ID, or find the SQL_ID a session is running. |  |
| [`flush_shared_pool.sql`](shared_pool/flush_shared_pool.sql) | Flush the entire shared pool. | read the warning in the header |
| [`purge_cursor.sql`](shared_pool/purge_cursor.sql) | Purge a single cursor from the shared pool so the next execution is hard parsed, instead of flushing the whole pool. | read the warning in the header |

### Optimizer statistics (`statistics/`)

| Script | What it does | Caution |
| --- | --- | --- |
| [`gather_statistics.sql`](statistics/gather_statistics.sql) | The DBMS_STATS calls for gathering database, dictionary, fixed object, schema, table and index statistics, with the options that matter. | read the warning in the header |
| [`stale_table_statistics.sql`](statistics/stale_table_statistics.sql) | Find tables whose optimizer statistics are stale or missing, and refresh them for one schema. | read the warning in the header |
| [`statistics_history_retention.md`](statistics/statistics_history_retention.md) | How to see how much statistics history is kept, change the retention, and purge old statistics and AWR snapshots when SYSAUX grows. | read the warning in the header |

### Tracing (`tracing/`)

| Script | What it does | Caution |
| --- | --- | --- |
| [`event_trace.sql`](tracing/event_trace.sql) | Enable and disable a numbered Oracle trace event at instance level, and check which events are currently set. | read the warning in the header |


## Conventions

- Every `.sql` file starts with the same header block: script name, purpose,
  usage, required privileges, versions it was used on, and a warning where the
  script is disruptive.
- Values that differ per environment are SQL*Plus substitution variables
  (`&&schema_name`, `&&sql_id`, `&&task_name`), never hard coded names.
- Statements that are destructive or expensive are left commented out, so that
  running a file by accident cannot damage a database.
- Longer procedures that mix shell commands, prose and SQL live in Markdown
  files rather than in mislabelled `.sql` files.
- Directories group scripts by subject: `sessions/`, `instance/`, `statistics/`,
  `plans/`, `shared_pool/`, `awr/`, `tracing/`.

`tools/check_repo.sh` enforces the mechanical part of this (headers present, LF
line endings, no credential patterns, no private IP addresses) and runs in CI on
every push and pull request:

```bash
./tools/check_repo.sh
```

## Contributing

Pull requests are welcome. Please keep the header block, use substitution
variables instead of environment specific names, comment out anything
destructive, and run `./tools/check_repo.sh` before opening the request.

## Licence

Released under the MIT Licence. Copyright (c) 2026 Mohamed Dawood.
See [LICENSE](LICENSE).
