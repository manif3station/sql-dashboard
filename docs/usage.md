# Usage

## Install

```bash
dashboard skills install git@github.mf:manif3station/sql-dashboard.git
```

Local workspace install:

```bash
dashboard skills install ~/projects/skills/skills/sql-dashboard
```

## Open The Page

```bash
dashboard restart
```

Then open:

```text
http://127.0.0.1:7890/app/sql-dashboard
```

## What You Should See

- `Connection Profiles`
- `SQL Workspace`
- `Schema Explorer`
- a driver selector
- the schema table filter box
- saved SQL controls next to the active collection

## Driver Setup

The workspace stays generic: database drivers are optional and user-installed.

Examples:

```bash
dashboard cpan DBD::SQLite
dashboard cpan DBD::mysql
dashboard cpan DBD::Pg
dashboard cpan DBD::ODBC
dashboard cpan DBD::Oracle
```

## Practical Normal Cases

- install the skill and open `/app/sql-dashboard`
- create a profile for one database family and save it for repeat use
- write and rerun SQL from the workspace editor
- browse schema metadata before writing a query against a less familiar table set

## Practical Edge Cases

- if no DBI driver is installed yet, the page still opens because the browser asset is separate from the runtime driver setup
- if a DB vendor needs native client libraries, install those separately before expecting that driver family to work
- if the shipped page ever changes, the exact-copy regression test will fail
