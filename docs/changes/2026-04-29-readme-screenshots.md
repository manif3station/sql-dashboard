# 2026-04-29 README screenshots

## Summary

Added real SQL dashboard screenshots to the skill README.

## What changed

- generated profile, workspace, and schema explorer screenshots with Playwright inside the shared Docker test container
- stored the PNG assets under `docs/images/`
- embedded the screenshots into `README.md` with short explanations of each view
- added a repo test that proves the PNG assets exist and are referenced by the README

## Why

The SQL dashboard is a browser-first skill. Real screenshots make it easier for users to understand what they land on after install.
