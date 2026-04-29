use strict;
use warnings;

use File::Spec;
use File::Temp qw(tempdir);
use Test::More;

BEGIN {
    eval { require DBI; 1 } or plan skip_all => 'DBI is required';
    eval { DBI->install_driver('SQLite'); 1 } or plan skip_all => 'DBD::SQLite is required';
}

my $tmp = tempdir( CLEANUP => 1, TMPDIR => 1 );
my $html_path = File::Spec->catfile( $tmp, 'sql-dashboard-demo.html' );
my $db_path   = File::Spec->catfile( $tmp, 'sql-dashboard-demo.sqlite' );
my $script    = File::Spec->catfile( 't', 'build-readme-demo-html.pl' );

my $cmd = join q{ },
  $^X,
  $script,
  $html_path,
  $db_path;

my $output = qx{$cmd 2>&1};
my $exit = $? >> 8;
is( $exit, 0, "demo HTML builder exits cleanly\n$output" );
ok( -f $html_path, 'demo HTML file is written' );
ok( -f $db_path,   'demo SQLite database is written' );

open my $fh, '<', $html_path or die "Unable to read $html_path: $!";
local $/;
my $html = <$fh>;
close $fh or die "Unable to close $html_path: $!";

like( $html, qr/Demo SQLite Catalog/, 'demo HTML includes the SQLite profile name' );
like( $html, qr/Inventory Snapshot/, 'demo HTML includes the saved SQL collection item' );
like( $html, qr/products/, 'demo HTML includes the products schema fixture' );

done_testing;
