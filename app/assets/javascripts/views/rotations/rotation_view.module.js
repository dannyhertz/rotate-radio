var RotationView = Backbone.View.extend({
  tagName: 'div',

  className: 'rotation',

  template: HoganTemplates['rotations/index'],

  render: function () {
    this.$el.html(this.template.render());

    return this;
  }
});

module.exports = RotationView;