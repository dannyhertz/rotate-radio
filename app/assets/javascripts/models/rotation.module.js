var _ = require('/underscore');
var Backbone = require('/backbone');
var Artists = require('/collections/artists');

var Rotation = Backbone.Model.extend({
  urlRoot: '/rotations',

  initialize: function () {
    this.set('artists', new Artists(this.get('artists')));
  }

});

module.exports = Rotation;