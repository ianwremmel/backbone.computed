# Backbone.Computed [![Build Status](https://travis-ci.org/ianwremmel/backbone.computed.png)](https://travis-ci.org/ianwremmel/backbone.computed)

## Motivation
Sometimes, attributes need to be manipulated in a consistent, reusable way, but in a fashion that does not (or cannot) be stored. Examples include fullnames based on first and last name or currencies based on a stored value and a recent conversion rate.

### Requirements:
1. [x] Trigger change event when dependent fields change.
2. [ ] ~~Support assignment model binding plugins.~~
  - This is quite difficult in the general case, and probably not as useful as it seems.
3. [x] Support view updates via model binding plugins.
4. [x] Use same syntax as regular attributes (e.g. model.get('computedAttr')).
5. [x] The computed values should not be a part of the Model's JSON representation by default.
6. [x] Computed fields should not be alterable without the developer explicitly indicating he or she is altering a computed field.

## Prior Work

At the time this plugin was started, the only prior work I found were a few comments from Derick Bailey that seemed positive but hesitant. Apparently, he subsequently wrote [backbone.compute](https://github.com/derickbailey/backbone.compute) and Alexander Beletsky wrote [backbone.computedfields](https://github.com/alexanderbeletsky/backbone-computedfields). Both seem solid, but I have several philosphical issues with each, though the main issue shared by both is the way in which they are initialized. In my opinion, both are overly obtrusive: in addition to putting configuration data on the Model, each requires invoking an initalize method in the Model's `initialize` function. In my opinion, this type of plugin should alter Backbone core either at load time or via a global initialize (at this time, backbone.computed alters core at load time - I intend to change to a global initalize and add eventually add a mixin method).

## Usage Example

```javascript
var attributes = {
  firstName: 'first',
  lastName: 'last'
};

var options = {
  computedFields: {
    fullName: 
      fields: [
        'firstName',
        'lastName'
      ],
      converter: function() {
        return this.get('firstName') + ' ' + this.get('lastName')
      }
    initials:
      fields: [
        'firstName',
        'lastName'
      ],
      includeInJSON: true,
      converter: function() {
        return this.get('firstName').substr(0, 1) + this.get('lastName').substr(0, 1);
      }
    }
  }
}

var model = new Backbone.Model(attributes, options);
```

Calling `model.set({firstName: 'newFirstName'})` will trigger change events for `firstName` and `fullName` and update `fullName`. `fullName` may not be updated during the change event for `firstName`.

### Options

#### fields
Type: `Array`
Default: `[]`

Dependent fields for the computation.

#### includeInJSON
Type: `Boolean`
Default: `false`

Indicates whether or not the field should be included in the hash returned by `toJSON()`.

#### converter
Type: `Function`
Default: `{}`

The function for computing the fields value. `this` refers to the model instance.

## TODO
- Support use as a mixin or as a direct alteration to Backbone core.
- Performance Testing
- Add tests for ModelBinder

## Future
- Investigate bi-directional computation (e.g. split a fullName into a firstName and a lastName)
