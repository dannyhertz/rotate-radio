var _ = require('/underscore');
var Backbone = require('/backbone');

var NotificationView = Backbone.View.extend({
  className: 'alert notification',
  template: HoganTemplates['shared/notification'],

  initialize: function () {},

  render: function () {    
    // add proper alert class
    switch (this.options.type) {
      case 'success':
        this.$el.addClass('alert-success');
        break;
      case 'error':
        this.$el.addClass('alert-error');
        break;
      case 'info':
        this.$el.addClass('alert-info');
    }

    this.$el.html(this.template.render({ header: this.options.header, message: this.options.message }));

    return this;
  },

  show: function () {
    // adjust the horizontal positioning
    var notifyWidth = this.$el.outerWidth();
    this.$el.css('margin-left', notifyWidth * -0.5);

    // slide the notification down and start the timer
    this.$el.slideDown(function () {
      _.delay(this.hide.bind(this), NotificationView.REMOVAL_TIMEOUT);
    }.bind(this));
  },

  hide: function () {
    this.$el.slideUp(function () {
      $(this).remove();
    });
  }
},
{
  REMOVAL_TIMEOUT: 3500,

  globalNotify: function (type, options) {
    var $navWrapper = $('.navbar .container');
    var allOptions = _.extend({}, options, { type: type });
    var globalNotifyView = new NotificationView(allOptions);

    $navWrapper.append(globalNotifyView.render().$el);
    globalNotifyView.show();
  },

  alertNotify: function (options) {
    NotificationView.globalNotify('alert', options);
  },

  successNotify: function (options) {
    NotificationView.globalNotify('success', options);
  },

  infoNotify: function (options) {
    NotificationView.globalNotify('info', options);
  },

  errorNotify: function (options) {
    NotificationView.globalNotify('error', options); 
  }
});

module.exports = NotificationView;