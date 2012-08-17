var _ = require('/underscore');
var Backbone = require('/backbone');
var Rotation = require('/models/rotation');
var RotationView = require('/views/rotations/show');

var HomeView = Backbone.View.extend({
  className: 'home',

  template: HoganTemplates['rotations/home'],

  initialize: function () {
    this.collection.on('reset', this.renderLatestRotation, this);
  },

  render: function () {
    this.$el.html(this.template.render());

    this.$latestRotation = this.$('.latest-rotation');
    this.$latestRotation.empty();

    return this;
  },

  renderLatestRotation: function (rotations) {
    this.$latestRotation.empty();

    var rotationView = new RotationView({ model: rotations.at(0) });
    this.$latestRotation.append(rotationView.render().$el);
  }
});

module.exports = HomeView;