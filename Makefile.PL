use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'testns',
    AUTHOR              => q{Miroslav Suchy <miroslav@suchy.cz>},
    VERSION_FROM        => 'lib/testns.pm',
    ABSTRACT            => 'Just some test',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl, GPL')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3126,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'testns-*' },
);
