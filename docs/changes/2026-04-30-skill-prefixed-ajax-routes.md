# 2026-04-30 Skill-Prefixed Ajax Routes

- renamed the saved ajax worker files to local names under `dashboards/ajax/`
- aligned the page with DD's `/ajax/sql-dashboard/...` route contract
- recorded that DD applies the same skill-prefixed route family to `/app`, `/ajax`, `/js`, `/css`, and `/others`
- updated tests to prove the route contract and worker-body matching instead of only checking a copied page hash
