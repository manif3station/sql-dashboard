use strict;
use warnings FATAL => 'all';

use File::Spec;
use File::Temp qw(tempdir tempfile);
use Test::More;

use lib 'lib';

use SQLDashboard::Asset;

my $node_bin     = _find_command('node');
my $chromium_bin = _find_command(qw(chromium chromium-browser google-chrome google-chrome-stable));

plan skip_all => 'Playwright smoke test requires node and Chromium on PATH'
  if !$node_bin || !$chromium_bin || !$ENV{NODE_PATH};

my $tmp = tempdir( CLEANUP => 1, TMPDIR => 1 );
my $html_path = File::Spec->catfile( $tmp, 'sql-dashboard.html' );
open my $html_fh, '>', $html_path or die "Unable to write $html_path: $!";
print {$html_fh} SQLDashboard::Asset::static_html();
close $html_fh or die "Unable to close $html_path: $!";

my ( $script_fh, $script_path ) = tempfile( 'sql-dashboard-playwright-XXXXXX', SUFFIX => '.js', TMPDIR => 1 );
print {$script_fh} <<'JS';
const { chromium } = require('playwright-core');

async function main() {
  const browser = await chromium.launch({
    executablePath: process.env.CHROMIUM_BIN,
    headless: true
  });
  const page = await browser.newPage();
  await page.goto(process.env.SQL_DASHBOARD_URL);
  const title = await page.title();
  const mainTabs = await page.locator('[data-sql-main-tab]').allTextContents();
  const workspaceTabs = await page.locator('[data-sql-workspace-tab]').allTextContents();
  const hasDriver = await page.locator('#sql-profile-driver').count();
  const hasFilter = await page.locator('#sql-table-filter').count();
  const hasCollectionsPanel = await page.locator('#sql-workspace-panel-collections').count();
  console.log(JSON.stringify({
    title,
    mainTabs,
    workspaceTabs,
    hasDriver,
    hasFilter,
    hasCollectionsPanel
  }));
  await browser.close();
}

main().catch((error) => {
  console.error(String(error && error.stack || error));
  process.exit(1);
});
JS
close $script_fh or die "Unable to close $script_path: $!";

my $cmd = join q{ },
  'NODE_PATH="' . $ENV{NODE_PATH} . '"',
  'CHROMIUM_BIN="' . $chromium_bin . '"',
  'SQL_DASHBOARD_URL="file://' . $html_path . '"',
  $node_bin,
  $script_path;
my $output = qx{$cmd 2>&1};
my $exit = $? >> 8;
is( $exit, 0, "Playwright smoke flow exits cleanly\n$output" );
my $payload = _json_decode($output);

is( $payload->{title}, 'SQL Dashboard', 'Playwright sees the SQL dashboard document title' );
is_deeply(
    $payload->{mainTabs},
    [ 'Connection Profiles', 'SQL Workspace', 'Schema Explorer' ],
    'Playwright sees the three main SQL dashboard tabs',
);
is_deeply(
    $payload->{workspaceTabs},
    [ 'Collection', 'Run SQL' ],
    'Playwright sees the merged SQL workspace subtabs',
);
is( $payload->{hasDriver}, 1, 'Playwright sees the driver selector' );
is( $payload->{hasFilter}, 1, 'Playwright sees the schema table filter' );
is( $payload->{hasCollectionsPanel}, 1, 'Playwright sees the collection workspace panel' );

done_testing;

sub _find_command {
    for my $name (@_) {
        for my $dir ( split /:/, $ENV{PATH} || q{} ) {
            my $path = File::Spec->catfile( $dir, $name );
            return $path if -x $path;
        }
    }
    return;
}

sub _json_decode {
    my ($text) = @_;
    require JSON::PP;
    return JSON::PP::decode_json($text);
}
