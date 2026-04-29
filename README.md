# sql-dashboard

## Description

`sql-dashboard` is a Developer Dashboard skill that gives users a browser-based SQL workspace inside DD.

## Value

It gives developers, operators, and analysts one place to manage connection profiles, write and rerun SQL, browse schema details, and inspect results without leaving Developer Dashboard.

## Problem It Solves

SQL work often gets split across terminal sessions, ad hoc client tools, copied DSNs, and temporary notes. That makes it harder to keep connection details, query collections, schema browsing, and result handling together in one repeatable workspace.

## What It Does To Solve It

This skill adds a SQL workspace to DD. It lets the user:

- create and save connection profiles
- choose from installed `DBD::*` drivers
- write and run SQL in the browser
- save useful SQL snippets into collections
- browse schema and column metadata
- inspect query results and shape rendered output through the workspace hooks

This repo proves the shipped skill page still loads and exposes the documented workspace controls. It does not re-run the full multi-database vendor matrix inside this ticket.

## Developer Dashboard Feature Added

This skill adds a browser page at:

- `http://127.0.0.1:7890/app/sql-dashboard`

## What Is Included

- a SQL workspace page at `dashboards/index`
- a database support report under `docs/database-support.md`
- Docker-only regression tests for copy integrity and browser layout smoke coverage

## Installation

Install the skill from its repo:

```bash
dashboard skills install git@github.mf:manif3station/sql-dashboard.git
```

For local development in this workspace:

```bash
dashboard skills install ~/projects/skills/skills/sql-dashboard
```

## How To Use It

Open the page in DD after install:

```bash
dashboard restart
```

Then visit:

```text
http://127.0.0.1:7890/app/sql-dashboard
```

The page provides:

- Connection Profiles
- SQL Workspace
- Schema Explorer
- saved SQL collections
- driver-aware DSN guidance

## Runtime Dependency Notes

This skill is a browser workspace. Query execution depends on `DBI` and whichever `DBD::*` driver matches the target database.

Examples:

```bash
dashboard cpan DBD::SQLite
dashboard cpan DBD::mysql
dashboard cpan DBD::Pg
dashboard cpan DBD::ODBC
dashboard cpan DBD::Oracle
```

## Normal Cases

```text
/app/sql-dashboard opens a SQL workspace with Connection Profiles, SQL Workspace, and Schema Explorer sections
```

```text
The page lets the user keep saved connection profiles, edit SQL, and browse schema details in one place
```

```text
The page runs SQL and returns result data through the workspace result area and saved SQL flow
```

## Edge Cases

```text
If no `DBD::*` drivers are installed, the page still renders but query execution and driver-specific work will not be usable until the user installs a driver.
```

```text
If a vendor driver needs native client libraries in addition to the Perl module, those host-side pieces must also be installed before that database family will work.
```

```text
If DD is not running, the browser route will not load until `dashboard restart` brings the web app back.
```

## Docs

- `docs/overview.md`
- `docs/usage.md`
- `docs/database-support.md`
- `docs/changes/2026-04-29-extraction.md`
- `docs/changes/2026-04-29-documentation-refresh.md`
