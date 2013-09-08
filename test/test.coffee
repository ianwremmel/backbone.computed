_ = require 'underscore'

# TODO The plugin shouldn't need to export Backbone.
Backbone = require '../lib/backbone.computed.js'

chai = require 'chai'
assert = chai.assert

describe 'Model', ->
	describe '#set()', ->
		model = null

		beforeEach ->
			attributes =
				firstName: 'first'
				lastName: 'last'

			options =
				computedFields:
					fullName:
						fields: [
							'firstName'
							'lastName'
						]
						converter: ->
							this.get('firstName') + ' ' + this.get('lastName')

			model = new Backbone.Model attributes, options

		it 'should throw an exception when setting a computed field without the {isComputed:true} option', ->
			assert.throws ->
				model.set fullName: 'FULLNAME'

		it 'should change the value of a computed field wehn setting a computed field with the {isComptued:true} option', ->
			model.set {fullName: 'FULLNAME'}, {isComputed: true}
			assert.equal model.get('fullName'), 'FULLNAME'

		it 'should fire the `change` event', ->

		it 'should first the change:<attribute-name> event', ->

		it 'should recompute the value when one of its depencies changes', ->
			model.set firstName: 'FIRST'
			assert.equal model.get('fullName'), 'FIRST last'

	describe '#computedFields', ->
		model = null

		beforeEach ->
			attributes =
				firstName: 'first'
				lastName: 'last'

			options =
				computedFields:
					fullName:
						fields: [
							'firstName'
							'lastName'
						]
						converter: ->
							this.get('firstName') + ' ' + this.get('lastName')

			model = new Backbone.Model attributes, options

			it 'should create the computed field', ->
				assert model.has 'fullName'

			it 'should initially compute the field from the available attributes', ->
				assert.equal model.get('fullName'), 'first last'

	describe '#toJSON()', ->
		attributes = null
		options = null

		beforeEach ->
			attributes =
				firstName: 'first'
				lastName: 'last'

			options =
				computedFields:
					fullName:
						fields: [
							'firstName'
							'lastName'
						]
						converter: ->
							this.get('firstName') + ' ' + this.get('lastName')

		it 'should include depencies in JSON', ->
			model = new Backbone.Model attributes, options
			json = model.toJSON()

			assert.isDefined json.firstName
			assert.isDefined json.lastName

		it 'should not include computed fields', ->
			model = new Backbone.Model attributes, options
			json = model.toJSON()

			assert.isUndefined json.fullName

		it 'should include computed fields if explicitly specified', ->
			options.computedFields.fullName.includeInJSON = true

			model = new Backbone.Model attributes, options
			json = model.toJSON()

			assert.isDefined json.fullName

