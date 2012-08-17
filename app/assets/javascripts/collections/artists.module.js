var Backbone = require('/backbone'),
    Artist = require('/models/artist');

var Artists = Backbone.Collection.extend({
  model: Artist,

  initialize: function () {}
});

module.exports = Artists;