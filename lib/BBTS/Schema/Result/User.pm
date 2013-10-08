package BBTS::Schema::Result::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('users');

__PACKAGE__->add_columns(
	id => {
		accessor          => 'user',
		data_type         => 'integer',
		size              => 16,
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	dn => {
		data_type         => 'varchar',
		size              => 256,
		is_nullable       => 1,
	},
	firstname => {
		data_type         => 'varchar',
		size              => 128,
		is_nullable       => 0,
	},
	lastname => {
		data_type         => 'varchar',
		size              => 128,
		is_nullable       => 0,
	},
	age => {
		data_type         => 'integer',
		size              => 8,
		is_nullable       => 1,
	},
	unit => {
		data_type         => 'varchar',
		size              => 32,
		is_nullable       => 1,
	},
	login => {
		data_type   => 'varchar',
		size        => 16,
		is_nullable => 1,
	},
	passwd => {
		data_type   => 'varchar',
		size        => 16,
		is_nullable => 1,
	}
);

__PACKAGE__->set_primary_key('id');

1;