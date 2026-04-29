use strict;
use warnings;

use Test::More;

use lib 'lib';

use SQLDashboard::Asset;

is(
    SQLDashboard::Asset::source_sha256(),
    'd5d90bd8cb2dde1fa472ebc217d44451c1524fffad0c8014f18fcf7c3fb6b234',
    'dashboards/index stays an exact copy of the current DD sql-dashboard source asset',
);

done_testing;
