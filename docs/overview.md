# Overview

`sql-dashboard` is a browser workspace for SQL work inside Developer Dashboard.

It exists so database work can stay inside DD while still giving the user practical tools for connection management, query execution, saved SQL, and schema browsing.

The page includes:

- Connection Profiles
- SQL Workspace
- Schema Explorer
- saved Ajax worker definitions for profile bootstrap, profile save, profile delete, collection save, collection delete, SQL execution, and schema browsing
- DD-backed ajax routing through flat handler names such as `/ajax/sql-dashboard-profiles-bootstrap?type=json`

In practical terms, the skill helps the user keep profiles, DSN guidance, SQL collections, result handling, and schema inspection together instead of spreading that work across shell history and separate database clients.
