# Testing

## Policy

- tests run only inside Docker
- the shared test container definition lives at the workspace root
- this skill keeps its test files in `t/`
- Playwright is used for the browser-facing smoke check because this skill exposes a browser page

## Commands

```bash
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . && prove -lr t'
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'
```

## Latest Verification

- Date: 2026-04-29
- Functional test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . && prove -lr t'`
  - Result: pass
  - Test count: `Files=4, Tests=18`
- Coverage test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'`
  - Result: pass
  - Coverage: `100.0%` statement and `100.0%` subroutine for `lib/SQLDashboard/Asset.pm`
- Installed DD proof:
  - `dashboard skills install ~/projects/skills/skills/sql-dashboard`
  - Result: pass, installed `sql-dashboard` at version `0.01`
  - `dashboard serve --host 127.0.0.1 --port 7890 --foreground`
  - Result: pass, served the installed skill route
  - `curl http://127.0.0.1:7890/app/sql-dashboard`
  - Result: pass, returned the SQL dashboard page with `Connection Profiles`, `SQL Workspace`, `Schema Explorer`, `sql-profile-driver`, and `sql-table-filter`
- Cleanup:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'rm -rf /workspace/skills/sql-dashboard/cover_db'`
  - Result: pass
