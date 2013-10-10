package BBTS::Schema::Result::Task;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('tasks');

__PACKAGE__->add_columns(
	id => {
		accessor          => 'task',
		data_type         => 'integer',
		is_nullable       => 0,
		is_auto_increment => 1,
	},
	title => {
		data_type   => 'text',
		is_nullable => 0,
	},
	desc => {
		data_type   => 'text',
		is_nullable => 1,
	},
	start_date => {
		data_type   => 'text',
		is_nullable => 0,
	},
	effort => {
		data_type   => 'integer',
		is_nullable => 0,
	},
	assignee => {
		data_type   => 'integer',
		is_nullable => 1,
	},
	parent => {
		data_type   => 'integer',
		is_nullable => 1,
	},
	predecessor => {
		data_type   => 'integer',
		is_nullable => 1,
	},
);
__PACKAGE__->belongs_to( 'assignee', 'BBTS::Schema::Result::User',
	{ 'foreign.id' => 'self.assignee' } );
__PACKAGE__->has_many( 'followers', 'BBTS::Schema::Result::Task', { 'foreign.predecessor' => 'self.id' } );
__PACKAGE__->has_many( 'subtasks',    'BBTS::Schema::Result::Task', { 'foreign.parent' => 'self.id' } );
__PACKAGE__->set_primary_key('id');

1;
