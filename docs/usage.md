# Usage

## Install

```bash
dashboard skills install git@github.com:manif3station/sql-dashboard.git
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

## Driver Setup

The copied page keeps the DD SQL dashboard behavior: database drivers are still optional and user-installed.

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
- review the copied SQL workspace layout before connecting to a real database
- install one `DBD::*` driver and then use the profile editor against that database family

## Practical Edge Cases

- if no DBI driver is installed yet, the page still opens because the browser asset is separate from the runtime driver setup
- if a DB vendor needs native client libraries, install those separately before expecting that driver family to work
- if the copied page ever drifts from DD core, the exact-copy regression test will fail
