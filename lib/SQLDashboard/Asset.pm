package SQLDashboard::Asset;

use strict;
use warnings;

use Digest::SHA qw(sha256_hex);
use File::Basename qw(dirname);
use File::Spec;

sub skill_root {
    my $root = File::Spec->rel2abs(
        File::Spec->catdir( dirname(__FILE__), File::Spec->updir(), File::Spec->updir() )
    );
    return $root;
}

sub dashboard_path {
    return File::Spec->catfile( skill_root(), 'dashboards', 'index' );
}

sub source_text {
    my $path = dashboard_path();
    open my $fh, '<', $path or die "Unable to read $path: $!";
    local $/;
    my $text = <$fh>;
    close $fh or die "Unable to close $path: $!";
    return $text;
}

sub source_sha256 {
    return sha256_hex( source_text() );
}

sub parse_bookmark {
    my $text = source_text();
    my ($title)    = $text =~ /^TITLE:\s*(.+)$/m;
    my ($bookmark) = $text =~ /^BOOKMARK:\s*(.+)$/m;
    my ($html)     = $text =~ /^HTML:\s*([\s\S]*?)^CODE1:/m;
    my @codes      = $text =~ /^(CODE\d+):\s+Ajax[\s\S]*?file\s*=>\s*'([^']+)'/mg;

    die "Missing title\n"    if !defined $title;
    die "Missing bookmark\n" if !defined $bookmark;
    die "Missing HTML block\n" if !defined $html;

    my @code_pairs;
    while (@codes) {
        my $label = shift @codes;
        my $file  = shift @codes;
        push @code_pairs, { label => $label, file => $file };
    }

    return {
        title       => $title,
        bookmark    => $bookmark,
        html        => $html,
        ajax_blocks => \@code_pairs,
    };
}

sub static_html {
    my $page = parse_bookmark();
    my $stub = <<'JS';
<script>
window.set_chain_value = function(root, path, value) {
  var parts = String(path || '').split('.');
  var cursor = root;
  while (parts.length > 1) {
    var part = parts.shift();
    cursor[part] = cursor[part] || {};
    cursor = cursor[part];
  }
  cursor[parts.shift()] = value;
  return root;
};
window.dashboard_ajax_singleton_cleanup = function() {};
window.fetch = async function() {
  return {
    ok: true,
    json: async function() {
      return {
        ok: true,
        profiles: [],
        collections: [],
        drivers: ['DBD::Mock'],
        results: [],
        html: '',
        details: {}
      };
    },
    text: async function() { return ''; }
  };
};
window.alert = function() {};
</script>
JS

    return join '',
      "<!doctype html>\n",
      "<html lang=\"en\">\n",
      "<head>\n<meta charset=\"utf-8\">\n<title>",
      $page->{title},
      "</title>\n",
      $stub,
      "\n</head>\n<body>\n",
      $page->{html},
      "\n</body>\n</html>\n";
}

1;
