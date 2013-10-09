package BBTS;

use strict;
use warnings;

our $VERSION = '0.1';

use Dancer2;
use Dancer2::Plugin::REST;
use Dancer2::Plugin::DBIC qw(schema resultset rset);
use BBTS::Schema;

#hook before => sub {
#    if (!session('user') && request->dispatch_path !~ m{^/login}) {
#        forward '/login', { requested_path => request->dispatch_path };
#    }
#};

get '/login' => sub {
  template 'login', { path => param('requested_path'), title_page => "Login" };
};

post '/login' => sub {
    # Validate the username and password they supplied
    if (param('user') eq 'bob' && param('pass') eq 'letmein') {
        session user => param('user');
        redirect param('path') || '/';
    } else {
        redirect '/login?failed=1';
    }
};

get '/' => sub {
	send_file 'index.html';
};

get '/usermgr' => sub {
	template 'usermgr', { path => param('requested_path'), title_page => "User management" };
};

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

true;

