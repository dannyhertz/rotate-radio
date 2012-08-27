var _ = require('/underscore');
var Backbone = require('/backbone');

var ArtistView = Backbone.View.extend({
  tagName: 'li',
  className: 'rotation-artist',

  template: HoganTemplates['artists/show'],

  initialize: function () {},

  render: function () {
    this.$el.html(this.template.render(this.model.toJSON()));

    return this;
  }

});

module.exports = ArtistView;