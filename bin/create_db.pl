use strict;
use warnings;

use BBTS::Schema;


my $db = BBTS::Schema->connect('dbi:SQLite:dbname=bbts.sqlite');
$db->deploy();