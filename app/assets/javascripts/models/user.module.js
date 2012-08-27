var _ = require('/underscore');
var Backbone = require('/backbone');
var Rotation = require('/models/rotation');

var User = Backbone.Model.extend({
  urlRoot: '/users',

  fetchCurrentRotation: function (callbacks) {
    var xhr = $.ajax({
      url: '/users/' + this.get('id') + '/rotations.json',
      type: 'GET'
    });
    xhr.done(function (response) {
      if (!!response.length) {
        var newRotation = new Rotation(response[0]);
        this.set('currentRotation', newRotation);
      }
      if (callbacks && callbacks.done) {
        callbacks.done(this.get('currentRotation'));
      }
    }.bind(this));
    xhr.fail(function () {
      if (callbacks && callbacks.fail) {
        callbacks.fail();
      }
    });
  },

  refreshRotation: function (callbacks) {
    var xhr = $.ajax({
      url: '/users/' + this.get('id') + '/rotations/refresh.json',
      type: 'POST'
    });
    xhr.done(function (response) {
      if (!!response) {
        var newRotation = new Rotation(response);
        this.set('currentRotation', newRotation);
      }
      if (callbacks && callbacks.done) {
        callbacks.done(!!response ? this.get('currentRotation') : false);
      }
    }.bind(this));
    xhr.fail(function () {
      if (callbacks && callbacks.fail) {
        callbacks.fail();
      }
    });
  }
});

module.exports = User;