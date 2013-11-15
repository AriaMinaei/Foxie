Transformation = require 'transformation'
css = require '../../../../utility/css'

module.exports = class Transforms_

	__initMixinTransforms: ->

		@_transformer = new Transformation

		@_origin =

			x: null

			y: null

			z: null

		@_shouldUpdateTransforms = no

		return

	__clonerForTransforms: (newStyleSetter) ->

		newStyleSetter._shouldUpdateTransforms = no

		return

	_updateTransforms: ->

		return unless @_shouldUpdateTransforms

		@_shouldUpdateTransforms = no

		do @_actuallyUpdateTransforms

	_scheduleTransformsUpdate: ->

		@_shouldUpdateTransforms = yes

		do @_scheduleUpdate

	_actuallyUpdateTransforms: ->

		css.setTransform @node, @_transformer.toPlainCss()

		@

	go3d: ->

		css.setTransformStyle @node, 'preserve-3d'

		@

	goFlat: ->

		css.setTransformStyle @node, 'flat'

		@

	setOrigin: (x = 0, y = 0, z = 0) ->

		@_origin.x = x
		@_origin.y = y
		@_origin.z = z

		css.setTransformOrigin @node,

			"#{@_origin.x}px #{@_origin.y}px #{@_origin.z}px"

		do @el._updateAxis

		@

	originToBottom: ->

		css.setTransformOrigin @node,

			"50% 100%"

		@

	originToTop: ->

		css.setTransformOrigin @node,

			"50% 0"

		@

	pivot: (x = 0, y = 0) ->

		if x is -1

			_x = '0%'

		else if x is 0

			_x = '50%'

		else if x is 1


			_x = '100%'

		else

			throw Error "pivot() only takes -1, 0, and 1 for its arguments"

		if y is -1

			_y = '0%'

		else if y is 0

			_y = '50%'

		else if y is 1


			_y = '100%'

		else

			throw Error "pivot() only takes -1, 0, and 1 for its arguments"

		css.setTransformOrigin @node,

			"#{_x} #{_y}"

		do @el._updateAxis

		@

ClassPrototype = Transforms_.prototype

for methodName, method of Transformation.prototype

	continue unless method instanceof Function

	continue if ClassPrototype[methodName]?

	continue if methodName[0] is '_'

	continue if methodName is 'temporarily' or methodName is 'commit' or
		methodName is 'rollBack' or methodName is 'toCss' or
		methodName is 'toPlainCss' or methodName is 'toArray' or
		methodName is 'toMatrix'

	do ->

		_methodName = methodName

		if method.length is 0

			ClassPrototype[_methodName] =  ->

				# This is more performant than method.apply()
				#
				# Argument splats won't work here though.
				@_transformer[_methodName]()

				do @_scheduleTransformsUpdate

				@

		else if method.length is 1

			ClassPrototype[_methodName] = (arg0) ->

				@_transformer[_methodName] arg0

				do @_scheduleTransformsUpdate

				@

		else if method.length is 2

			ClassPrototype[_methodName] = (arg0, arg1) ->

				@_transformer[_methodName] arg0, arg1

				do @_scheduleTransformsUpdate

				@

		else if method.length is 3

			ClassPrototype[_methodName] = (arg0, arg1, arg2) ->

				@_transformer[_methodName] arg0, arg1, arg2

				do @_scheduleTransformsUpdate

				@

		else if method.length is 4

			ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3) ->

				@_transformer[_methodName] arg0, arg1, arg2, arg3

				do @_scheduleTransformsUpdate

				@

		else if method.length is 5

			ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3, arg4) ->

				@_transformer[_methodName] arg0, arg1, arg2, arg3, arg4

				do @_scheduleTransformsUpdate

				@

		else

			throw Error "Methods with more than 5 args are not supported."

Transforms_