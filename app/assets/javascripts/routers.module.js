var Backbone = require('/backbone');
var Rotation = require('/models/rotation'),
    User = require('/models/user');
var Rotations = require('/collections/rotations');
var HomeView = require('/views/rotations/home_view');

var Router = Backbone.Router.extend({

  routes: {
    '': 'home',
    'artists/:id': 'artistDetails',
    'settings': 'settings'
  },

  initialize: function (options) {
    if (options.currentUser) {
      this.currentUser = new User(options.currentUser);
    }

    this.$contentHolder = $('.content-holder');
    this.$contentHolder.empty();
  },

  home: function () {
    this.homeView = new HomeView({ 
      currentUser: this.currentUser 
    });
    this.currentUser.fetchCurrentRotation();

    this.$contentHolder.html(this.homeView.render().$el);
  },

  artistDetails: function (id) {
    console.log('artist details for ', id);
  },

  settings: function () {
    console.log('settings');
  }

});

module.exports = Router;