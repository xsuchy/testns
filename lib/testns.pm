package testns;
use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;

our $VERSION = '0.1';

# render html for subtree of specific id
sub get_subtree {
    my ($root) = @_;
    my $result = qq|<li>$root|;
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
    $result = $result . $subtree . '</li>';
    return $result;
}

any '/' => sub {
    # I can use Dancer::Plugin::Database, but that would be super-easy.
    # Let show some coding.
    my $sth = $main::testns_dbh->prepare(q|select id from nodes where parent = 0;|);
    if (!$sth->execute()) {
        die("Error ". DBI->errstr);
    }
    my $tree;
    if ($sth->rows == 0) {
      $tree = "";
      flash error => "Requirements said there will be some rows. Read README.txt and populate DB.";
    } else {
      my ($root) = $sth->fetchrow_array;
      $tree = qq|<ul id="org" style="display:none">| . get_subtree($root) . q|</ul>|;
    }
    template 'index' => { tree => $tree,
        add_entry_url =>  uri_for('/'),
    };
};

true;
