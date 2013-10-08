package BBTS::User;
use Moo;

our $VERSION = '0.1';

has 'first_name' => ( is => 'rw' );
has 'last_name'  => ( is => 'rw' );
has 'unit'       => ( is => 'rw' );
has 'email'      => ( is => 'rw' );
has 'id'         => ( is => 'ro' );

sub display_name {
	my $self = shift;
	return
	    $self->first_name . " "
	  . $self->last_name . " ("
	  . $self->unit . ")";
}

1;
