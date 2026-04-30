# Testing

## Policy

- tests run only inside Docker
- the shared test container definition lives at the workspace root
- this skill keeps its test files in `t/`
- Playwright is used for the browser-facing smoke check because this skill exposes a browser page

## Commands

```bash
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && cpanm --quiet --notest --installdeps . && prove -lr t'
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && cpanm --quiet --notest --installdeps . && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && mkdir -p docs/images && perl t/build-readme-demo-html.pl /tmp/sql-dashboard-readme.html /tmp/sql-dashboard-readme.sqlite && SQL_DASHBOARD_SCREENSHOT_HTML=/tmp/sql-dashboard-readme.html SQL_DASHBOARD_SCREENSHOT_DIR=/workspace/skills/sql-dashboard/docs/images node t/generate-readme-screenshots.js'
```

## Latest Verification

- Date: 2026-04-29
- Functional test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && cpanm --quiet --notest --installdeps . && prove -lr t'`
  - Result: pass
  - Test count: `Files=7, Tests=50`
- Coverage test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && cpanm --quiet --notest --installdeps . && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'`
  - Result: pass
  - Coverage: `100.0%` statement and `100.0%` subroutine for `lib/SQLDashboard/Asset.pm`
- Screenshot generation:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && mkdir -p docs/images && perl t/build-readme-demo-html.pl /tmp/sql-dashboard-readme.html /tmp/sql-dashboard-readme.sqlite && SQL_DASHBOARD_SCREENSHOT_HTML=/tmp/sql-dashboard-readme.html SQL_DASHBOARD_SCREENSHOT_DIR=/workspace/skills/sql-dashboard/docs/images node t/generate-readme-screenshots.js'`
  - Result: pass
  - Assets: `docs/images/sql-dashboard-profiles.png`, `docs/images/sql-dashboard-workspace.png`, `docs/images/sql-dashboard-schema.png`
  - Backing demo: `DBD::SQLite` with a dummy SQLite catalog created at runtime inside Docker
- Installed DD proof:
  - `dashboard skills install ~/projects/skills/skills/sql-dashboard`
  - Result: pass, updated `sql-dashboard` to version `0.08`
  - `dashboard restart --port 7890`
  - Result: pass, DD web returned on `127.0.0.1:7890`
  - `curl -fsS http://127.0.0.1:7890/app/sql-dashboard | rg -n "Connection Profiles|SQL Workspace|Schema Explorer|sql-profile-driver|sql-table-filter"`
  - Result: pass, returned the SQL dashboard page with the documented workspace controls
  - `curl -fsS http://127.0.0.1:7890/ajax/sql-dashboard/profiles-bootstrap?type=json`
  - Result: pass, returned the bootstrap payload JSON from the skill-prefixed ajax route
- Cleanup:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'rm -rf /workspace/skills/sql-dashboard/cover_db'`
  - Result: pass
