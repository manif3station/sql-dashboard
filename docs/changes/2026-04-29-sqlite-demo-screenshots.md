# 2026-04-29 SQLite demo screenshots

## Summary

Replaced the SQL dashboard README screenshots with views generated from a real SQLite demo database inside Docker.

## What changed

- added a Docker-time SQLite demo database builder for the screenshot workflow
- generated profile, workspace, and schema explorer screenshots from a populated SQL dashboard state
- added a repo test that proves the SQLite demo HTML builder runs cleanly when `DBD::SQLite` is available
- updated screenshot captions to explain that the README images show a working SQLite example

## Why

The earlier screenshots showed too much empty-state behavior. The README now demonstrates the SQL dashboard with real data so the skill looks functional on first read.
