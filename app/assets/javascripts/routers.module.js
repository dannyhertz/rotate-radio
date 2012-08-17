var Backbone = require('/backbone');
var Rotation = require('/models/rotation');
var Rotations = require('/collections/rotations');
var HomeView = require('/views/rotations/home');

var Router = Backbone.Router.extend({

  routes: {
    '': 'home',
    'artists/:id': 'artistDetails',
    'settings': 'settings'
  },

  initialize: function () {
    console.log('initializing the router');
    this.$contentHolder = $('.content-holder');
  },

  home: function () {
    var latestRotations = new Rotations();
    this.homeView = new HomeView({ collection: latestRotations });
    latestRotations.fetch({ data: { type: 'latest' } });

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