var _ = require('/underscore');
var Backbone = require('/backbone');
var ArtistView = require('/views/artists/show');

var RotationView = Backbone.View.extend({
  className: 'rotation',

  template: HoganTemplates['rotations/show'],

  initialize: function () {},

  render: function () {
    this.$el.html(this.template.render(this.model.toJSON()));

    this.$artistList = this.$('.rotation-artists');

    _.each(this.model.get('artists').models, function (artist) {
      var artistView = new ArtistView({ model: artist });
      this.$artistList.append(artistView.render().$el);
    }, this);

    return this;
  }
});

module.exports = RotationView;