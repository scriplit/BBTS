package BBTS::Schema::Result::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('users');

__PACKAGE__->add_columns(
	id => {
		accessor          => 'user',
		data_type         => 'integer',
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	dn => {
		data_type         => 'text',
		is_nullable       => 1,
	},
	firstname => {
		data_type         => 'text',
		is_nullable       => 0,
	},
	lastname => {
		data_type         => 'text',
		is_nullable       => 0,
	},
	age => {
		data_type         => 'integer',
		is_nullable       => 1,
	},
	unit => {
		data_type         => 'text',
		is_nullable       => 1,
	},
	login => {
		data_type   => 'text',
		is_nullable => 1,
	},
	passwd => {
		data_type   => 'text',
		is_nullable => 1,
	}
);

__PACKAGE__->set_primary_key('id');

1;