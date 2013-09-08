// This test suite was written on an airplane (WOO!! HAWAII!!) without access to
// NPM, so there was no way to get supporting files for an actual test library
// (or for instructions for using same).

// TODO Add a test confirming use of both the options hash on the derived
// instance hash.

'use strict';

require('../lib/backbone.computed.js');
var Backbone = require('backbone');

var attributes = {
	firstName: 'first',
	lastName: 'last',
};

var options = {
	computedFields: {
		fullName: {
			fields: [
				'firstName',
				'lastName'
			],
			includeInJSON: false,
			converter: function() {
				return this.get('firstName') + ' ' + this.get('lastName');
			}
		}
	}
};

var model = new Backbone.Model(attributes, options);

var pass = false;
try {
	model.set({fullName: 'FULLNAME'});
} catch (e) {
	pass = true;
}
if (!pass) {
	throw new Error('attempting to set computedField without isComputed:true attribute should have thrown an Error');
}


model = new Backbone.Model(attributes, options);
model.set({fullName: 'FULLNAME'}, {isComputed: true});
if (model.get('fullName') !== 'FULLNAME') {
	throw new Error('fullName should have been updated to FULLNAME but is instead "' + model.get('fullName') + '"');
}


model = new Backbone.Model(attributes, options);
if (!model.has('fullName')) {
	throw new Error('fullName should exist');
}

if (model.get('fullName') !== 'first last') {
	throw new Error('fullName should equal "first last" but instead is "' + model.get('fullName') + '"');
}

pass = false;

model.on('change', function(model, options) {
	if (model.get('lastName') !== 'LAST') {
		throw new Error('lastName should be "LAST" but was "' + model.get('lastName') + '"');
	}

	if (model.get('fullName') !== 'first LAST') {
		throw new Error('fullName should be "first LAST" but was "' + model.get('fullName') + '"');
	}

	pass = true;
});

model.set({lastName: 'LAST'});

if (!pass) {
	throw new Error('change callback did not execute');
}

model = new Backbone.Model(attributes, options);
pass = false;

model.on('change:fullName', function(model, attribute, options) {
	if (attribute !== 'FIRST last') {
		throw new Error ('attribute should be "FIRST last" but was "' + attribute + '"');
	}
	pass = true;
});

model.set({firstName: 'FIRST'});

if (!pass) {
	throw new Error('change:fullName callback did not execute');
}

// jshint eqeqeq:false
var json = model.toJSON();
if (json.firstName == null) {
	throw new Error('firstName should be part of JSON');
}

if (json.lastName == null) {
	throw new Error('lastName should be part of JSON');
}

if (json.fullName != null) {
	throw new Error('fullName should not be part of JSON');
}


var options = {
	computedFields: {
		initials: {
			fields: [
				'firstName',
				'lastName'
			]
		},
		includeInJSON: true,
		converter: function() {
			return this.get('firstName').substr(0, 1) + this.get('lastName').substr(0,1);
		}
	},
};

var model = new Backbone.Model(attributes, options);
var json = model.toJSON();
if (json.firstName == null) {
	throw new Error('firstName should be part of JSON');
}

if (json.lastName == null) {
	throw new Error('lastName should be part of JSON');
}

if (json.fullName == null) {
	throw new Error('fullName should be part of JSON');
}
// jshint eqeqeq:true

