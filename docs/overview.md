# Overview

`sql-dashboard` is an extracted copy of the current DD SQL dashboard page.

It exists so the SQL workspace can live as an isolated skill repo with its own release cycle, tests, docs, version metadata, and changelog instead of being reachable only from DD core.

The copied page includes:

- Connection Profiles
- SQL Workspace
- Schema Explorer
- saved Ajax worker definitions for profile bootstrap, profile save, profile delete, collection save, collection delete, SQL execution, and schema browsing

This skill intentionally keeps the browser page source as a copied DD asset. It does not re-implement the SQL dashboard in a separate Perl module.
