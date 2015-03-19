#!/usr/bin/env perl
use Dancer;
use Dancer::Config::Object;
use DBI;
use testns;

$main::db_user=config->{'db_user'};
$main::db_password=config->{'db_password'};
$main::db_options=config->{'db_hostname'};
$main::db_database=config->{'db_database'};
$main::db_driver=config->{'db_driver'};
$main::dsn=qq|DBI:$main::db_driver:database=$main::db_database;$main::db_options|;

# under mod_perl this will result in no-op and significantly improve performance
$main::testns_dbh = DBI->connect($main::dsn, $main::db_user, $main::db_password) or die "Error connecting to database\n";

dance;
