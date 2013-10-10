package BBTS;

use strict;
use warnings;

our $VERSION = '0.1';

use Dancer2;
use Dancer2::Plugin::REST;
use Dancer2::Plugin::DBIC qw(schema resultset rset);
use BBTS::Schema;

get '/login' => sub {
	template 'login',
	  { path => param('requested_path'), title_page => "Login" };
};

post '/login' => sub {

	# Validate the username and password they supplied
	if ( param('user') eq 'bob' && param('pass') eq 'letmein' ) {
		session user => param('user');
		redirect param('path') || '/';
	}
	else {
		redirect '/login?failed=1';
	}
};


# --------- Start ---------------

get '/' => sub {
	template 'bbts', { title_page => "Busy Bear Task Server" };
};

# --------- Users ---------------

get '/users' => sub {
	my @set = rset('User')->all;
	my $ret = [];
	for my $e (@set) {
		push @$ret,
		  {
			id        => $e->id,
			login     => $e->login,
			lastname  => $e->lastname,
			firstname => $e->firstname,
			unit      => $e->unit
		  };
	}
	return to_json($ret);
};

resource 'user' => 'get' => \&on_get_user,
  'create'      => \&on_create_user,
  'delete'      => \&on_delete_user,
  'update'      => \&on_update_user;

sub on_get_user {
	my $id   = params->{'id'};
	my @user = rset('User')->find($id);
	if ( @user == 1 ) {
		my $e = $user[0];
		return to_json(
			{
				id        => $e->id,
				login     => $e->login,
				lastname  => $e->lastname,
				firstname => $e->firstname,
				unit      => $e->unit
			}
		);
	}
	else {
		return to_json( status_not_found("user doesn't exist") );
	}
}

sub on_create_user {
	my $ctx         = shift;
	my $user        = from_json( $ctx->request->body() );
	my $userCreated = rset('User')->create($user);
	to_json($userCreated);
}

sub on_delete_user {
	my $id = params->{'id'};
	if ( defined $id ) {
		my @userSet = rset('User')->find($id);
		if ( @userSet == 1 ) {
			$userSet[0]->delete;
			return to_json( status_ok("user deleted") );
		}
		else {
			return to_json( status_not_found("user doesn't exist") );
		}
	}
	else {
		return to_json( status_not_found("no user id") );
	}
}

sub on_update_user {
	my $ctx  = shift;
	my $user = from_json( $ctx->request->body() );
	my $id   = $user->{id};
	if ( defined $id ) {
		my @userSet = rset('User')->find($id);
		if ( @userSet == 1 ) {
			$userSet[0]->update(
				{
					login     => $user->{login},
					firstname => $user->{firstname},
					lastname  => $user->{lastname},
					unit      => $user->{unit},
				}
			);
			return to_json( status_ok("user updated") );
		}
		else {
			return to_json( status_not_found("user doesn't exist") );
		}
	}
	else {
		return to_json( status_not_found("no user id") );
	}
}

# --------- Tasks --------------

get '/tasks' => sub {
	my @set = rset('Task')->all;
	my $ret = [];
	for my $e (@set) {
		push @$ret,
		  {
			id     => $e->id,
			title  => $e->title,
			desc   => $e->desc,
			start  => $e->start,
			effort => $e->effort
		  };
	}
	return to_json($ret);
};

resource 'task' => 'get' => \&on_get_task,
  'create'      => \&on_create_task,
  'delete'      => \&on_delete_task,
  'update'      => \&on_update_task;


sub on_get_task {
	my $id   = params->{'id'};
	my @task = rset('Task')->find($id);
	if ( @task == 1 ) {
		my $e = $task[0];
		return to_json(
			{
				id     => $e->id,
				title  => $e->title,
				desc   => $e->desc,
				start  => $e->start,
				effort => $e->effort
			}
		);
	}
	else {
		return to_json( status_not_found("task doesn't exist") );
	}
}

sub on_create_task {
	my $ctx         = shift;
	my $task        = from_json( $ctx->request->body() );
	my $taskCreated = rset('Task')->create($task);
	to_json($taskCreated);
}

sub on_delete_task {
	my $id = params->{'id'};
	if ( defined $id ) {
		my @taskSet = rset('Task')->find($id);
		if ( @taskSet == 1 ) {
			$taskSet[0]->delete;
			return to_json( status_ok("task deleted") );
		}
		else {
			return to_json( status_not_found("task doesn't exist") );
		}
	}
	else {
		return to_json( status_not_found("no task id") );
	}
}

sub on_update_task {
	my $ctx  = shift;
	my $task = from_json( $ctx->request->body() );
	my $id   = $task->{id};
	if ( defined $id ) {
		my @taskSet = rset('Task')->find($id);
		if ( @taskSet == 1 && defined $taskSet[0]) {
			$taskSet[0]->update(
				{
					title  => $task->{title},
					desc   => $task->{desc},
					start  => $task->{start},
					effort => $task->{effort},
				}
			);
			return to_json( status_ok("task updated") );
		}
		else {
			return to_json( status_not_found("task doesn't exist") );
		}
	}
	else {
		return to_json( status_not_found("no user id") );
	}
}

true;

