use strict;
use warnings;

use DBI;
use File::Spec;
use JSON::PP qw(encode_json);

use lib 'lib';

use SQLDashboard::Asset;

my $output_html = shift @ARGV or die "Usage: $0 OUTPUT_HTML DB_PATH\n";
my $db_path     = shift @ARGV or die "Usage: $0 OUTPUT_HTML DB_PATH\n";

my $dbh = DBI->connect(
    "dbi:SQLite:dbname=$db_path",
    q{},
    q{},
    {
        RaiseError => 1,
        PrintError => 0,
        AutoCommit => 1,
    },
) or die DBI->errstr;

_seed_demo_db($dbh);

my $profiles = [
    {
        name          => 'Demo SQLite Catalog',
        driver        => 'DBD::SQLite',
        dsn           => "dbi:SQLite:dbname=$db_path",
        user          => q{},
        password      => q{},
        save_password => 0,
        attrs_json    => '{"RaiseError":1,"PrintError":0,"AutoCommit":1}',
        connection_id => "dbi:SQLite:dbname=$db_path|",
    },
];

my $collections = [
    {
        name  => 'Demo Queries',
        items => [
            {
                id   => 'inventory-snapshot',
                name => 'Inventory Snapshot',
                sql  => 'select sku, name, category, price, stock from products order by sku;',
            },
            {
                id   => 'recent-orders',
                name => 'Recent Orders',
                sql  => 'select order_no, customer_name, status, total from orders order by order_no desc;',
            },
        ],
    },
];

my $drivers = ['DBD::SQLite'];

my $result_rows = $dbh->selectall_arrayref(
    'select sku, name, category, price, stock from products order by sku',
    { Slice => {} },
);

my $result_html = _rows_to_html(
    $result_rows,
    [ qw(sku name category price stock) ],
);

my $result_details = {
    driver        => 'DBD::SQLite',
    dsn           => "dbi:SQLite:dbname=$db_path",
    row_count     => scalar @{$result_rows},
    executed_sql  => 'select sku, name, category, price, stock from products order by sku;',
    selected_cols => [ qw(sku name category price stock) ],
};

my $tables = $dbh->selectall_arrayref(
    q{
        select name as TABLE_NAME
        from sqlite_master
        where type = 'table' and name not like 'sqlite_%'
        order by name
    },
    { Slice => {} },
);

my $columns = _table_columns($dbh, 'products');

my $fixture = {
    bootstrap => {
        ok          => JSON::PP::true,
        profiles    => $profiles,
        collections => $collections,
        drivers     => $drivers,
        errors      => [],
    },
    execute => {
        ok      => JSON::PP::true,
        html    => $result_html,
        details => $result_details,
    },
    schema => {
        products => {
            ok             => JSON::PP::true,
            tables         => $tables,
            columns        => $columns,
            selected_table => 'products',
        },
    },
};

my $page = SQLDashboard::Asset::parse_bookmark();
my $fixture_json = encode_json($fixture);

my $stub = <<"JS";
<script>
window.SQL_DASHBOARD_DEMO_FIXTURE = $fixture_json;
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
window.alert = function() {};
window.fetch = async function(url, options) {
  options = options || {};
  var fixture = window.SQL_DASHBOARD_DEMO_FIXTURE || {};
  var payload = {};

  if (String(url).indexOf('/ajax/sql-dashboard/profiles-bootstrap') > -1) {
    payload = fixture.bootstrap || {};
  } else if (String(url).indexOf('/ajax/sql-dashboard/execute') > -1) {
    payload = fixture.execute || {};
  } else if (String(url).indexOf('/ajax/sql-dashboard/schema-browse') > -1) {
    var body = String(options.body || '');
    var params = new URLSearchParams(body);
    var settings = {};
    try {
      settings = JSON.parse(params.get('settings') || '{}');
    } catch (error) {
      settings = {};
    }
    var tableName = settings.table_name || 'products';
    payload = ((fixture.schema || {})[tableName]) || ((fixture.schema || {}).products) || {};
  } else {
    payload = { ok: true };
  }

  return {
    ok: true,
    text: async function() {
      return JSON.stringify(payload);
    }
  };
};
</script>
JS

open my $fh, '>', $output_html or die "Unable to write $output_html: $!";
print {$fh} join q{},
  "<!doctype html>\n",
  "<html lang=\"en\">\n",
  "<head>\n<meta charset=\"utf-8\">\n<title>",
  $page->{title},
  "</title>\n",
  $stub,
  "\n</head>\n<body>\n",
  $page->{html},
  "\n</body>\n</html>\n";
close $fh or die "Unable to close $output_html: $!";

$dbh->disconnect;

sub _seed_demo_db {
    my ($dbh) = @_;

    $dbh->do('drop table if exists products');
    $dbh->do('drop table if exists orders');
    $dbh->do('drop table if exists customers');

    $dbh->do(
        q{
            create table products (
                sku text primary key,
                name text not null,
                category text not null,
                price real not null,
                stock integer not null
            )
        }
    );
    $dbh->do(
        q{
            create table customers (
                customer_id integer primary key,
                customer_name text not null,
                tier text not null
            )
        }
    );
    $dbh->do(
        q{
            create table orders (
                order_no integer primary key,
                customer_name text not null,
                status text not null,
                total real not null
            )
        }
    );

    my $product_sth = $dbh->prepare('insert into products (sku, name, category, price, stock) values (?, ?, ?, ?, ?)');
    $product_sth->execute('BK-100', 'Keyboard', 'Peripherals', 79.95, 14);
    $product_sth->execute('MO-220', 'Mouse', 'Peripherals', 39.50, 32);
    $product_sth->execute('ST-310', 'Monitor Stand', 'Furniture', 129.00, 7);

    my $customer_sth = $dbh->prepare('insert into customers (customer_id, customer_name, tier) values (?, ?, ?)');
    $customer_sth->execute(1, 'Northwind Studio', 'gold');
    $customer_sth->execute(2, 'Atlas Lab', 'silver');

    my $order_sth = $dbh->prepare('insert into orders (order_no, customer_name, status, total) values (?, ?, ?, ?)');
    $order_sth->execute(5003, 'Northwind Studio', 'shipped', 248.45);
    $order_sth->execute(5004, 'Atlas Lab', 'processing', 129.00);
}

sub _rows_to_html {
    my ( $rows, $columns ) = @_;
    my $html = '<table><thead><tr>';
    for my $column ( @{$columns} ) {
        $html .= '<th>' . _escape_html($column) . '</th>';
    }
    $html .= '</tr></thead><tbody>';
    for my $row ( @{$rows} ) {
        $html .= '<tr>';
        for my $column ( @{$columns} ) {
            my $value = defined $row->{$column} ? $row->{$column} : q{};
            $html .= '<td><pre>' . _escape_html($value) . '</pre></td>';
        }
        $html .= '</tr>';
    }
    $html .= '</tbody></table>';
    return $html;
}

sub _table_columns {
    my ( $dbh, $table_name ) = @_;
    my $pragma = $dbh->selectall_arrayref(
        "pragma table_info($table_name)",
        { Slice => {} },
    );

    return [
        map {
            {
                TABLE_NAME   => $table_name,
                COLUMN_NAME  => $_->{name},
                TYPE_NAME    => $_->{type},
                TYPE_LABEL   => $_->{type},
                LENGTH_LABEL => q{},
            }
        } @{$pragma}
    ];
}

sub _escape_html {
    my ($text) = @_;
    $text = q{} if !defined $text;
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/"/&quot;/g;
    return $text;
}
