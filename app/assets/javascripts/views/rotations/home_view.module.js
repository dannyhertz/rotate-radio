var _ = require('/underscore');
var Backbone = require('/backbone');
var Rotation = require('/models/rotation');
var RotationView = require('/views/rotations/rotation_view');
var NotificationView  = require('/views/shared/notification_view');

var HomeView = Backbone.View.extend({
  className: 'home',
  template: HoganTemplates['rotations/home'],

  events: {
    'click .status-actions': 'onRotationStatusToggle',
    'click .refresh-link': 'onRotationRefresh'
  },

  initialize: function () {
    this.currentUser = this.options.currentUser;
    
    this.currentUser.on('change:currentRotation', this.renderCurrentRotation, this);
    this.currentUser.on('change:rotation_status', this.renderRotationButtons, this);
  },

  render: function () {
    this.$el.html(this.template.render());

    this.$currentRotation = this.$('.current-rotation');
    this.$rotationActions = this.$('.rotation-actions');
    this.$notifications = this.$('.notify-holder');
    
    this.$currentRotation.empty();

    this.renderRotationButtons(this.currentUser);
    
    return this;
  },

  renderCurrentRotation: function (user) {
    this.$currentRotation.empty();

    var rotationView = new RotationView({ model: user.get('currentRotation') });
    this.$currentRotation.append(rotationView.render().$el);
  },

  onRotationStatusToggle: function (e) {
    e.preventDefault();
    
    var desiredStatus = this.currentUser.get('rotation_status') == 0 ? 1 : 0;

    this.currentUser.set({ 'rotation_status': desiredStatus });
    this.currentUser.save();
  },

  onRotationRefresh: function (e) {
    e.preventDefault();

    var that = this;
    this.currentUser.refreshRotation({
      done: function(response) {
        var notificationView;
        if (response) {
          NotificationView.successNotify({
            header: 'Huzzah!',
            message: 'Your rotation was successfully updated' 
          });
        } else {
          NotificationView.infoNotify({
            header: 'Oh well!',
            message: 'Your rotation has not changed' 
          });
        }
      }
    })
  },

  renderRotationButtons: function (user) {
    var newToggleStatus = user.get('rotation_status');
    this.$rotationActions.toggleClass('resumed', !!newToggleStatus);
  }

});

module.exports = HomeView;