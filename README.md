# sql-dashboard

## Description

`sql-dashboard` is a Developer Dashboard skill that extracts the current DD SQL dashboard into an isolated skill repo.

## Value

It gives users a browser-facing SQL workspace they can install as a skill instead of relying on the page being shipped only from DD core.

## Problem It Solves

The DD SQL dashboard exists in the main DD source as a large seeded browser page. This skill packages that same SQL dashboard page into a standalone skill repo so it can be installed, reviewed, versioned, and released independently.

## What It Does To Solve It

This skill copies the current DD SQL dashboard page source into `dashboards/index`, preserves the original bookmark content, and ships the supporting skill-local docs that explain what the extracted page does and what database-driver setup the user still needs.

This repo re-proves copy integrity and browser layout smoke coverage. It does not re-run the full DD-core multi-database vendor matrix inside this extraction ticket.

## Developer Dashboard Feature Added

This skill adds a browser page at:

- `http://127.0.0.1:7890/app/sql-dashboard`

## What Is Included

- the DD SQL dashboard page source copied into `dashboards/index`
- the SQL dashboard database support report under `docs/database-support.md`
- Docker-only regression tests for copy integrity and browser layout smoke coverage

## Installation

Install the skill from its repo:

```bash
dashboard skills install git@github.com:manif3station/sql-dashboard.git
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

## Runtime Dependency Notes

The copied page is a browser workspace. Query execution still depends on DBI and whichever `DBD::*` driver matches the target database.

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
/app/sql-dashboard opens the copied SQL dashboard page
```

```text
The page shows Connection Profiles, SQL Workspace, and Schema Explorer tabs
```

```text
The page keeps the original saved Ajax worker names used by the DD SQL dashboard
```

## Edge Cases

```text
If no `DBD::*` drivers are installed, the page still renders but query execution and driver-specific work will not be usable until the user installs a driver.
```

```text
The database support matrix documented in docs/database-support.md is copied from the DD source and marked as inherited DD-core evidence, not re-proven by this skill repo's smaller extraction gate.
```

```text
If DD is not running, the browser route will not load until `dashboard restart` brings the web app back.
```

## Docs

- `docs/overview.md`
- `docs/usage.md`
- `docs/database-support.md`
- `docs/changes/2026-04-29-extraction.md`
