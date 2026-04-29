# 2026-04-29 extraction

## Summary

Created the `sql-dashboard` skill by extracting the current DD SQL dashboard page into a new isolated skill repo.

## What changed

- copied the DD SQL dashboard page source into `dashboards/index`
- copied the SQL dashboard database support report into `docs/database-support.md`
- added a small skill-local helper module to parse and render the copied asset for tests
- added Docker-only regression tests for exact-copy integrity, bookmark structure, and browser layout smoke coverage

## Why

The SQL dashboard was previously only represented as a DD-core seeded page. This extraction gives it a skill-local home with its own release gate.
