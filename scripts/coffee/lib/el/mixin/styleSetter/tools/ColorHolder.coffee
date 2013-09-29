define ['../../../../utility/css/Color'], (CSSColor) ->

	class ColorHolder

		constructor: (@_callback) ->

			@_color = new CSSColor

		withRgb: (r, g, b) ->

			@_color.fromRgb r, g, b

			do @_callback

			@

		withHsl: (h, s, l) ->

			@_color.fromHsl h, s, l

			do @_callback

			@

		clone: (callback) ->

			newObj = Object.create @constructor::

			newObj._color = @_color.clone()

			newObj._callback = callback

			newObj

	ClassPrototype = ColorHolder.prototype

	for methodName, method of CSSColor.prototype

		continue unless method instanceof Function

		continue if ClassPrototype[methodName]?

		continue if methodName[0] is '_'

		continue if methodName.substr(0, 2) is 'to'

		do ->

			_methodName = methodName

			if method.length is 0

				ClassPrototype[_methodName] =  ->

					# This is more performant than method.apply()
					#
					# Argument splats won't work here though.
					@_color[_methodName]()

					do @_callback

					@

			else if method.length is 1

				ClassPrototype[_methodName] = (arg0) ->

					@_color[_methodName] arg0

					do @_callback

					@

			else if method.length is 2

				ClassPrototype[_methodName] = (arg0, arg1) ->

					@_color[_methodName] arg0, arg1

					do @_callback

					@

			else if method.length is 3

				ClassPrototype[_methodName] = (arg0, arg1, arg2) ->

					@_color[_methodName] arg0, arg1, arg2

					do @_callback

					@

			else if method.length is 4

				ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3) ->

					@_color[_methodName] arg0, arg1, arg2, arg3

					do @_callback

					@

			else if method.length is 5

				ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3, arg4) ->

					@_color[_methodName] arg0, arg1, arg2, arg3, arg4

					do @_callback

					@

			else

				throw Error "Methods with more than 5 args are not supported."

	ColorHolder