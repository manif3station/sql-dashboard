use strict;
use warnings;

use File::Spec;
use Test::More;

my $root = File::Spec->rel2abs(
    File::Spec->catdir( File::Spec->curdir() )
);

my @images = (
    File::Spec->catfile( $root, 'docs', 'images', 'sql-dashboard-profiles.png' ),
    File::Spec->catfile( $root, 'docs', 'images', 'sql-dashboard-workspace.png' ),
    File::Spec->catfile( $root, 'docs', 'images', 'sql-dashboard-schema.png' ),
);

for my $image (@images) {
    ok( -f $image, "$image exists" );
    ok( -s $image, "$image is not empty" );
    open my $fh, '<:raw', $image or die "Unable to read $image: $!";
    my $header = q{};
    read $fh, $header, 8;
    close $fh or die "Unable to close $image: $!";
    is( $header, "\x89PNG\x0d\x0a\x1a\x0a", "$image has a PNG header" );
}

my $readme = File::Spec->catfile( $root, 'README.md' );
open my $readme_fh, '<', $readme or die "Unable to read $readme: $!";
local $/;
my $readme_text = <$readme_fh>;
close $readme_fh or die "Unable to close $readme: $!";

like( $readme_text, qr{docs/images/sql-dashboard-profiles\.png}, 'README references the profiles screenshot' );
like( $readme_text, qr{docs/images/sql-dashboard-workspace\.png}, 'README references the workspace screenshot' );
like( $readme_text, qr{docs/images/sql-dashboard-schema\.png}, 'README references the schema screenshot' );

done_testing;
