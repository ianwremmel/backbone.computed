(function() {
'use strict';

// TODO this a temporary means of loading Backbone.
// jshint node: true
var Backbone = require('../bower_components/backbone/backbone.js');
var _ = require('lodash');
// jshint node: false

// Duckpunch the Model constructor. Core-Hacking FTW!
var constructor = Backbone.Model;
var Model = function(attributes, options) {
  if (options.computedFields != null) {
    this.computedFields = options.computedFields;
  }
  constructor.apply(this, arguments);
};
Model.prototype = Backbone.Model.prototype;
Backbone.Model = Model;


var set = Backbone.Model.prototype.set;
Backbone.Model.prototype.set = function(key, val, options) {
  var attrs;
  // Taken from Backbone.Model.set
  if (key == null) {
    return this;
  }

  if (typeof key === 'object') {
    attrs = key;
    options = val;
  } else {
    (attrs = {})[key] = val;
  }

  options = options || {};
  // End taken from Backbone.Model.set

  // Do a safety-check to make sure we're not setting a computed field
  // innapropriately. Computed fields should only be set at computation-time or,
  // possibly, during a fetch().
  if (options.isComputed !== true) {
    var computedKeys = _.keys(this.computedFields);
    _.each(attrs, function(val, key) {
      if (_.contains(computedKeys, key)) {
        throw new Error('Cannot set a computed field without the isComputed option.');
      }
    });
  }

  set.apply(this, arguments);
};

})();
