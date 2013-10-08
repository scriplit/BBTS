use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'BBTS',
    AUTHOR              => q{ennio <scriplit@yahoo.com>},
    VERSION_FROM        => 'lib/BBTS.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer2'     => 0.04,
        'DBIx::Class' => 0.08250,
        'Dancer2::Plugin::REST'=> 0.20,
        'Dancer2::Plugin::DBIC'=> 0.0004,
        'SQL::Translator'=> 0.11016,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'BBTS-*' },
);
