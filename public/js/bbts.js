function htmlEncode(value) {
	return $('<div/>').text(value).html();
}
$.fn.serializeObject = function() {
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() {
		if (o[this.name] !== undefined) {
			if (!o[this.name].push) {
				o[this.name] = [ o[this.name] ];
			}
			o[this.name].push(this.value || '');
		} else {
			o[this.name] = this.value || '';
		}
	});
	return o;
};

// $.ajaxPrefilter( function( options, originalOptions, jqXHR ) {
// options.url = 'http://localhost:3000' + options.url;
// });


// ----------- Users ------------

var Users = Backbone.Collection.extend({
	url : '/users'
});

var User = Backbone.Model.extend({
	urlRoot : '/user'
});

var UserListView = Backbone.View.extend({
	el : '.page',
	render : function() {
		var that = this;
		var users = new Users();
		users.fetch({
			success : function(users) {
				var template = _.template($('#user-list-template').html(), {
					users : users.models
				});
				that.$el.html(template);
			}
		})
	}
});

var userListView = new UserListView();

var UserEditView = Backbone.View.extend({
	el : '.page',
	events : {
		'submit .edit-user-form' : 'saveUser',
		'click .delete-user' : 'deleteUser'
	},
	saveUser : function(ev) {
		var userDetails = $(ev.currentTarget).serializeObject();
		var user = new User();
		user.save(userDetails, {
			success : function(user) {
				router.navigate('usermgr/', {
					trigger : true
				});
			}
		});
		return false;
	},
	deleteUser : function(ev) {
		this.user.destroy({
			success : function() {
				console.log('destroyed');
				router.navigate('usermgr/', {
					trigger : true
				});
			}
		});
		return false;
	},
	render : function(options) {
		var that = this;
		if (options.id) {
			that.user = new User({
				id : options.id
			});
			that.user.fetch({
				success : function(user) {
					var template = _.template($('#edit-user-template').html(),
							{
								user : user
							});
					that.$el.html(template);
				}
			})
		} else {
			var template = _.template($('#edit-user-template').html(), {
				user : null
			});
			that.$el.html(template);
		}
	}
});

var userEditView = new UserEditView();

// ----------- Tasks ------------

var Tasks = Backbone.Collection.extend({
	url : '/tasks'
});

var Task = Backbone.Model.extend({
	urlRoot : '/task'
});

var TaskListView = Backbone.View.extend({
	el : '.page',
	render : function() {
		var that = this;
		var tasks = new Tasks();
		tasks.fetch({
			success : function(tasks) {
				var template = _.template($('#task-list-template').html(), {
					tasks : tasks.models
				});
				that.$el.html(template);
			}
		})
	}
});

var taskListView = new TaskListView();

var TaskEditView = Backbone.View.extend({
	el : '.page',
	events : {
		'submit .edit-task-form' : 'saveTask',
		'click .delete-task' : 'deleteTask'
	},
	saveTask : function(ev) {
		var taskDetails = $(ev.currentTarget).serializeObject();
		var task = new Task();
		task.save(taskDetails, {
			success : function(task) {
				router.navigate('taskmgr/', {
					trigger : true
				});
			}
		});
		return false;
	},
	deleteTask : function(ev) {
		this.task.destroy({
			success : function() {
				console.log('destroyed');
				router.navigate('taskmgr/', {
					trigger : true
				});
			}
		});
		return false;
	},
	render : function(options) {
		var that = this;
		if (options.id) {
			that.task = new Task({
				id : options.id
			});
			that.task.fetch({
				success : function(task) {
					var template = _.template($('#edit-task-template').html(),
							{
								task : task
							});
					that.$el.html(template);
				}
			})
		} else {
			var template = _.template($('#edit-task-template').html(), {
				task : null
			});
			that.$el.html(template);
		}
	}
});

var taskEditView = new TaskEditView();


// ---------- Home ------------

var HomeView = Backbone.View.extend({
	el : '.page',
	render: function(options) {
		var template = _.template($('#home-template').html());
		this.$el.html(template);
	}
});
var homeView = new HomeView();

// ---------- Routes ----------

var Router = Backbone.Router.extend({
	routes : {
		"" : "home",
		"usermgr/" : "homeUser",
		"usermgr/edit/:id" : "editUser",
		"usermgr/new" : "editUser",
		"taskmgr/" : "homeTask",
		"taskmgr/edit/:id" : "editTask",
		"taskmgr/new" : "editTask",
	}
});

var router = new Router;
router.on('route:home', function() {
	// render home
	homeView.render();
})
router.on('route:homeUser', function() {
	// render user list
	userListView.render();
})
router.on('route:editUser', function(id) {
	userEditView.render({
		id : id
	});
})
router.on('route:homeTask', function() {
	// render user list
	taskListView.render();
})
router.on('route:editTask', function(id) {
	taskEditView.render({
		id : id
	});
})
Backbone.history.start();
