# Testing

## Policy

- tests run only inside Docker
- the shared test container definition lives at the workspace root
- this skill keeps its test files in `t/`
- Playwright is used for the browser-facing smoke check because this skill exposes a browser page

## Commands

```bash
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . DBD::SQLite && prove -lr t'
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . DBD::SQLite && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'
docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && mkdir -p docs/images && perl t/build-readme-demo-html.pl /tmp/sql-dashboard-readme.html /tmp/sql-dashboard-readme.sqlite && SQL_DASHBOARD_SCREENSHOT_HTML=/tmp/sql-dashboard-readme.html SQL_DASHBOARD_SCREENSHOT_DIR=/workspace/skills/sql-dashboard/docs/images node t/generate-readme-screenshots.js'
```

## Latest Verification

- Date: 2026-04-29
- Functional test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . && cpanm --quiet --notest DBD::SQLite && prove -lr t'`
  - Result: pass
  - Test count: `Files=6, Tests=36`
- Coverage test:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest --installdeps . && cpanm --quiet --notest DBD::SQLite && cover -delete && HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t && cover -report text -select_re "^lib/" -coverage statement -coverage subroutine'`
  - Result: pass
  - Coverage: `100.0%` statement and `100.0%` subroutine for `lib/SQLDashboard/Asset.pm`
- Screenshot generation:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'cd /workspace/skills/sql-dashboard && cpanm --quiet --notest DBD::SQLite && mkdir -p docs/images && perl t/build-readme-demo-html.pl /tmp/sql-dashboard-readme.html /tmp/sql-dashboard-readme.sqlite && SQL_DASHBOARD_SCREENSHOT_HTML=/tmp/sql-dashboard-readme.html SQL_DASHBOARD_SCREENSHOT_DIR=/workspace/skills/sql-dashboard/docs/images node t/generate-readme-screenshots.js'`
  - Result: pass
  - Assets: `docs/images/sql-dashboard-profiles.png`, `docs/images/sql-dashboard-workspace.png`, `docs/images/sql-dashboard-schema.png`
  - Backing demo: `DBD::SQLite` with a dummy SQLite catalog created at runtime inside Docker
- Installed DD proof:
  - `curl -fsS http://127.0.0.1:7890/app/sql-dashboard | rg -n "Connection Profiles|SQL Workspace|Schema Explorer|sql-profile-driver|sql-table-filter"`
  - Result: pass, returned the SQL dashboard page with the documented workspace controls
- Installed DD note:
  - `dashboard skills install ~/projects/skills/skills/sql-dashboard`
  - Result: blocked by the current local DD core runtime error `Developer/Dashboard.pm did not return a true value at ~/.developer-dashboard/cli/dd/_dashboard-core line 48`
  - Scope: unrelated to the `sql-dashboard` repo changes in this ticket
- Cleanup:
  - `docker compose -f ~/projects/skills/docker-compose.testing.yml run --rm perl-test bash -lc 'rm -rf /workspace/skills/sql-dashboard/cover_db'`
  - Result: pass
