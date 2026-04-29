const { chromium } = require('playwright-core');

async function capture(page, selector, path) {
  if (selector) {
    await page.click(selector);
    await page.waitForTimeout(250);
  }
  await page.screenshot({ path, fullPage: true });
}

async function main() {
  const htmlPath = process.env.SQL_DASHBOARD_SCREENSHOT_HTML;
  const outputDir = process.env.SQL_DASHBOARD_SCREENSHOT_DIR;
  const chromiumPath = process.env.CHROMIUM_BIN;

  if (!htmlPath) throw new Error('SQL_DASHBOARD_SCREENSHOT_HTML is required');
  if (!outputDir) throw new Error('SQL_DASHBOARD_SCREENSHOT_DIR is required');
  if (!chromiumPath) throw new Error('CHROMIUM_BIN is required');

  const browser = await chromium.launch({
    executablePath: chromiumPath,
    headless: true,
  });

  const page = await browser.newPage({
    viewport: { width: 1440, height: 1400 },
  });

  await page.goto(`file://${htmlPath}`, { waitUntil: 'load' });
  await page.waitForTimeout(600);

  await capture(page, null, `${outputDir}/sql-dashboard-profiles.png`);

  await page.click('[data-sql-main-tab="workspace"]');
  await page.waitForTimeout(250);
  await page.click('[data-sql-workspace-tab="collections"]');
  await page.waitForTimeout(250);
  await page.click('[data-sql-collection-item-link]');
  await page.waitForTimeout(250);
  await page.click('#sql-run');
  await page.waitForTimeout(400);
  await page.screenshot({ path: `${outputDir}/sql-dashboard-workspace.png`, fullPage: true });

  await page.click('[data-sql-main-tab="schema"]');
  await page.waitForTimeout(500);
  await page.screenshot({ path: `${outputDir}/sql-dashboard-schema.png`, fullPage: true });

  await browser.close();
}

main().catch((error) => {
  console.error(error && error.stack ? error.stack : String(error));
  process.exit(1);
});
