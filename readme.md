[![Build Status](https://travis-ci.org/ianwremmel/backbone.computed.png)](https://travis-ci.org/ianwremmel/backbone.computed)

# Motivation

Right now, things like fullname, roomEmailAddress, bookmarklet, etc, require special methods (and the knowledge of the existence of those methods). There are several existing plugins (or at least code samples) for doing this on the Internet, but the feeback from Derick Bailey and/or Jeremy Ashkenas was positive but hesitant.

# Requirements:
1. Trigger change event when dependent fields change
2. Support assignment via ModelBinder.
3. Trigger updates via ModelBinding.
4. Use same syntax as regular attributes (e.g. model.get('computedAttr')).

- Rather than building out a huge api for emitting events, add a `computedFields` hash to each model that contains a set of dependent fields and a compute function. Store the computed results via `set()`/`get() to trigger change events (this satisfies requirement 1, 3, and 4).
- Point 2 is impossible in the general case and extremely complex in many of the specific cases. Until we have a use case for it, it's not worth doing.
- The `computedFields` hash should support `includeInJSON` (`false` by default).
- `set()` should not allow altering a computed attribute without also passing an `isComputed:true` option (this way, computed field will be kept as read only unless they've been recomputed.

# TODO
- Add a grunt UMD builder
- Explain differences between this and Backbone.compute.
- Support use as a mixin or as a direct alteration to Backbone core.
- Performance Testing
- Add tests for ModelBinder
- Add tests Backbone.Relational

# Future
- Investigate bi-directional computation (e.g. split a fullName into a firstName and a lastName)
