use strict;
use warnings;

use Test::More;

use lib 'lib';

use SQLDashboard::Asset;

my $source = SQLDashboard::Asset::source_text();
my $sha    = SQLDashboard::Asset::source_sha256();

like( $sha, qr/\A[a-f0-9]{64}\z/, 'dashboards/index has a stable SHA-256 digest' );
like( $source, qr{/ajax/sql-dashboard-profiles-bootstrap\?type=json}, 'sql-dashboard bootstrap fallback keeps the current DD flat route' );
like( $source, qr{/ajax/sql-dashboard-profiles-save\?type=json}, 'sql-dashboard save fallback keeps the current DD flat route' );
like( $source, qr{/ajax/sql-dashboard-profiles-delete\?type=json}, 'sql-dashboard delete fallback keeps the current DD flat route' );
like( $source, qr{/ajax/sql-dashboard-collections-save\?type=json}, 'sql-dashboard collection save fallback keeps the current DD flat route' );
like( $source, qr{/ajax/sql-dashboard-collections-delete\?type=json}, 'sql-dashboard collection delete fallback keeps the current DD flat route' );
like( $source, qr{/ajax/sql-dashboard-execute\?type=json}, 'sql-dashboard execute fallback keeps the current DD flat route' );
like( $source, qr{/ajax/sql-dashboard-schema-browse\?type=json}, 'sql-dashboard schema browse fallback keeps the current DD flat route' );

done_testing;
