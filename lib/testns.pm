package testns;
use Dancer ':syntax';

our $VERSION = '0.1';

sub get_subtree {
    my ($root) = @_;
    my $result = qq|<li>$root</li>|;
    my $sth = $main::testns_dbh->prepare(q|select id from nodes where parent = ?|);
    if (!$sth->execute($root)) {
        die("Error ". DBI->errstr);
    }
    my $subtree;
    while (my ($id) = $sth->fetchrow_array) {
        $subtree .= "<li>$id (P:$root)</li>";
    }
    if ($subtree) {
        $subtree = qq|<ul>$subtree</ul>|;
    }
    return $result.$subtree;
}

get '/' => sub {
    # I can use Dancer::Plugin::Database, but that would be super-easy.
    # Let show some coding.
    my $sth = $main::testns_dbh->prepare(q|select id from nodes where parent = 0;|);
    if (!$sth->execute()) {
        die("Error ". DBI->errstr);
    }
    my $tree;
    if ($sth->rows == 0) {
      $tree = "Requirements said there will be some rows. Read README.txt and populate DB.";
    } else {
      my ($root) = $sth->fetchrow_array;
      $tree = qq|<ul id="org" style="display:none">| . get_subtree($root) . q|</ul>|;
    }
    template 'index' => { tree => $tree };
};

true;
