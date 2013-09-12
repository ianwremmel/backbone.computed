_ = require 'underscore'

# TODO changes test format from "it should" to "it does".

# TODO The plugin shouldn't need to export Backbone.
Backbone = require '../lib/backbone.computed.js'

chai = require 'chai'
assert = chai.assert

describe 'Model', ->

	it 'should not break Model inheritance', ->
		assert.isFunction Backbone.Model.extend

	it 'should not require `options` to be passed to the constructor'

	it 'should not require `attributes` to be passed to the constructor'

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

		it 'should fire the `change` event', (done) ->
			model.on 'change', ->
				done()
			model.set firstName: 'FIRST'

		it 'should fire the change:<attribute-name> event', (done)->
			model.on 'change:fullName', ->
				done()
			model.set firstName: 'FIRST'

		it 'should recompute the value when one of its dependencies changes', ->
			model.set firstName: 'FIRST'
			assert.equal model.get('fullName'), 'FIRST last'

	describe '#computedFields', ->
		describe 'onlyOnce', ->
			it 'should prevent recomputing the field if the field already exists'
			it 'should allow setting the field during fetch'

		model = null
		options = null
		attributes = null

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

		it 'should work as a function that returns a hash', ->
			fields = _.clone options.computedFields, true

			options.computedFields = ->
				fullName:
					fields: [
						'firstName'
						'lastName'
					]
					converter: ->
						this.get('firstName') + ' ' + this.get('lastName')

			model = new Backbone.Model attributes, options

			assert model.has 'fullName'
			assert.equal model.get('fullName'), 'first last'

		it 'should support a function-without-dependencies format'

		it 'should merge with Model.prototype.computedFields'

		it 'should support collections as dependencies'

		it 'should all dot notation to specify properties of collections as depencies'

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

					initials:
						fields: [
							'firstName'
							'lastName'
						]
						includeInJSON: true
						converter: ->
							this.get('firstName').substr(0, 1) + ' ' + this.get('lastName').substr(0, 1)

		it 'should include dependencies in JSON', ->
			model = new Backbone.Model attributes, options
			json = model.toJSON()

			assert.isDefined json.firstName
			assert.isDefined json.lastName

		it 'should not include computed fields', ->
			model = new Backbone.Model attributes, options
			json = model.toJSON()

			assert.isUndefined json.fullName

		it 'should include computed fields if explicitly specified', ->
			model = new Backbone.Model attributes, options
			json = model.toJSON()

			assert.isDefined json.initials

	describe '#get()', ->
		it 'accepts an options parameter'
