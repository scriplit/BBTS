package BBTS::UserCollection;
use Moo;
use List::AllUtils qw/ max firstval /;

our $VERSION = '0.1';

has users => (
	is  => 'rw',
	isa => sub {die "$_[0] is not an Array" unless ref $_[0] eq 'ARRAY';},
	default => sub { $_[0]->users( [] ) }
);


sub find_user_by_id {
	my ($self, $look_id) = @_;
	return firstval {$_->id eq $look_id} @{$self->users};
}

sub add_user {
	my ($self, $user) = @_;
	if (ref $user eq 'User') {
		$user->id = max (map {$_->id} @{$self->users}) + 1;
		push @{$self->users}, $user;
		return $user;
	}
	else {
		die "$_[0] is not a User" unless ref $_[0] eq 'User';
	} 
}

sub get_all_ref {
	my $self = shift;
	return $self->users;
}



1;
