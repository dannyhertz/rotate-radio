var Backbone = require('/backbone'),
    Rotation = require('/models/rotation');

var Rotations = Backbone.Collection.extend({
  model: Rotation,
  url: '/rotations',
  
  initialize: function () {}
});

module.exports = Rotations;