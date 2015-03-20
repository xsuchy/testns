package testns;
use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;
use Scalar::Util qw(looks_like_number);

our $VERSION = '0.1';

# render html for subtree of specific id
sub get_subtree {
    my ($root, $parent) = @_;
    my $result = qq|<li>$root (P: $parent)|;
    my $sth = $main::testns_dbh->prepare(q|select id from nodes where parent = ?|);
    if (!$sth->execute($root)) {
        die("Error ". DBI->errstr);
    }
    my $subtree = "";
    while (my ($id) = $sth->fetchrow_array) {
        $subtree .= get_subtree($id, $root);
    }
    if ($subtree) {
        $subtree = qq|<ul>$subtree</ul>|;
    }
    $result = $result . $subtree . '</li>';
    return $result;
}

# route for main (and only one page)
any '/' => sub {
    # I can use Dancer::Plugin::Database, but that would be super-easy.
    # Let show some coding.
    #flash error => "foo".params->{"newid"};
    if (defined params->{"newid"}) {
        if (looks_like_number(params->{"newid"}) and params->{"newid"}+0 > 0) {
            # sanitize the value
            my $newid = params->{"newid"}+0;
            my $sth = $main::testns_dbh->prepare(q|select id from nodes where id = ?|);
            if (!$sth->execute($newid)) {
                die("Error ". DBI->errstr);
            }
            if ($sth->rows > 0) {
                $sth = $main::testns_dbh->prepare(q|insert into nodes (parent) values (?)|);
                if (!$sth->execute($newid)) {
                    die("Error ". DBI->errstr);
                }
            } else {
                flash error => "Parent with this number does not exist.";
            }
        } else {
            # I assume that root ALWAYS exist in DB from initial deployment
            flash error => "Parent must be positive number";
        }
    }
    my $sth = $main::testns_dbh->prepare(q|select id from nodes where parent = 0;|);
    if (!$sth->execute()) {
        die("Error ". DBI->errstr);
    }
    my $tree;
    if ($sth->rows == 0) {
      $tree = "";
      flash error => "Requirements said there will be some rows. Read db part of README.txt and populate DB.";
    } else {
      my ($root) = $sth->fetchrow_array;
      $tree = qq|<ul id="org" style="display:none">| . get_subtree($root, "None") . q|</ul>|;
    }
    template 'index' => { tree => $tree,
        add_entry_url =>  uri_for('/'),
    };
};

true;
