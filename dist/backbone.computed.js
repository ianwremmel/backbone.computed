!function(e){"object"==typeof exports?module.exports=e():"function"==typeof define&&define.amd?define(e):"undefined"!=typeof window?window.backbonecomputed=e():"undefined"!=typeof global?global.backbonecomputed=e():"undefined"!=typeof self&&(self.backbonecomputed=e())}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';

var Backbone = require('backbone');
var _ = require('underscore');

// Duckpunch the Model constructor. Core-Hacking FTW!
var constructor = Backbone.Model;
var Model = function(attributes, options) {
  if (this.computedFields || (options && options.computedFields)) {
    // Merge the computedFields hash from options with the one on the Model
    // definition, assuming they exist.
    var computedFields = {};

    if (this.computedFields) {
      // _.result doesn't work here
      _.extend(computedFields, (typeof this.computedFields === 'function') ? this.computedFields() : this.computedFields);
    }

    if (options && options.computedFields) {
      // _.result doesn't work here
      _.extend(computedFields, (typeof options.computedFields === 'function') ? options.computedFields() : options.computedFields);
    }

    this.computedFields = computedFields;

    // Setup easy access to the names of the computedFields
    this.computedAttrs = _.keys(this.computedFields);

    // Find the reverse relations
    this.deps = {};
    _.each(this.computedFields, this._findDepencies, this);

    // Bind the converters to their change events
    _.each(this.deps, this._bindDepencies, this);
  }
  constructor.apply(this, arguments);
};

// TODO investigate better ways to migrate the prototype
Model.prototype = Backbone.Model.prototype;
_.each(_.functions(Backbone.Model), function(functionName) {
  Model[functionName] = Backbone.Model[functionName];
});

Backbone.Model = Model;


Backbone.Model.prototype._findDepencies = function(data, attr) {
  for (var i = 0; i < data.fields.length; i++) {
    if (!this.deps[data.fields[i]]) {
      this.deps[data.fields[i]] = [];
    }
    this.deps[data.fields[i]].push(attr);
  }
};

Backbone.Model.prototype._bindDepencies = function(computedFields, dependency) {

  for (var i = 0; i < computedFields.length; i++) {
    this.on('change:' + dependency, _.bind(this._computeField, this, computedFields[i]));
  }
};

Backbone.Model.prototype._computeField = function(computedField) {
  var result = this.computedFields[computedField].converter.apply(this);
  this.set(computedField, result, {isComputed: true});
};

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
    _.each(attrs, function(val, key) {
      if (_.contains(this.computedAttrs, key)) {
        throw new Error('Cannot set a computed field (' + key + ') without the isComputed option.');
      }
    }, this);
  }

  return set.apply(this, arguments);
};

var toJSON = Backbone.Model.prototype.toJSON;
Backbone.Model.prototype.toJSON = function() {
  var json = toJSON.apply(this, arguments);

  _.each(this.computedFields, function(data, field) {
    if (!data.includeInJSON) {
      delete json[field];
    }
  }, this);

  return json;
};

},{"backbone":false,"underscore":false}]},{},[1])
(1)
});