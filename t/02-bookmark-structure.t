use strict;
use warnings;

use Test::More;

use lib 'lib';

use SQLDashboard::Asset;

my $page = SQLDashboard::Asset::parse_bookmark();

is( $page->{title}, 'SQL Dashboard', 'bookmark keeps the DD SQL dashboard title' );
is( $page->{bookmark}, 'sql-dashboard', 'bookmark keeps the original bookmark id' );
like( $page->{html}, qr/Connection Profiles/, 'HTML keeps the connection profile panel' );
like( $page->{html}, qr/SQL Workspace/, 'HTML keeps the SQL workspace panel' );
like( $page->{html}, qr/Schema Explorer/, 'HTML keeps the schema explorer panel' );
like( $page->{html}, qr/id="sql-table-filter"/, 'HTML keeps the schema table filter control' );
like( $page->{html}, qr/id="sql-profile-driver"/, 'HTML keeps the driver selector' );
is( scalar @{ $page->{ajax_blocks} }, 7, 'bookmark keeps all seven saved Ajax workers' );
is_deeply(
    [ map { $_->{file} } @{ $page->{ajax_blocks} } ],
    [
        'profiles-bootstrap',
        'profiles-save',
        'profiles-delete',
        'collections-save',
        'collections-delete',
        'execute',
        'schema-browse',
    ],
    'bookmark keeps the expected saved Ajax worker file names',
);

done_testing;
