define [
	'../../../../visuals/Filter'
	'../../../../utility/css'
], (CSSFilter, css) ->

	class Filters_

		__initMixinFilters: ->

			@_cssFilter = new CSSFilter

			@_shouldUpdateFilters = no

		__clonerForFilters: (newStyleSetter) ->

			newStyleSetter._shouldUpdateFilters = no

			return

		_updateFilters: ->

			return unless @_shouldUpdateFilters

			@_shouldUpdateFilters = no

			do @_actuallyUpdateFilters

		_scheduleFiltersUpdate: ->

			@_shouldUpdateFilters = yes

			do @_scheduleUpdate

		_actuallyUpdateFilters: ->

			css.setCssFilter @node, @_cssFilter.toCss()

			@

	ClassPrototype = Filters_.prototype

	for methodName, method of CSSFilter.prototype

		continue unless method instanceof Function

		continue if ClassPrototype[methodName]?

		continue if methodName[0] is '_'

		continue if methodName is 'toCss'

		do ->

			_methodName = methodName

			if method.length is 0

				ClassPrototype[_methodName] =  ->

					# This is more performant than method.apply()
					#
					# Argument splats won't work here though.
					@_cssFilter[_methodName]()

					do @_scheduleFiltersUpdate

					@

			else if method.length is 1

				ClassPrototype[_methodName] = (arg0) ->

					@_cssFilter[_methodName] arg0

					do @_scheduleFiltersUpdate

					@

			else if method.length is 2

				ClassPrototype[_methodName] = (arg0, arg1) ->

					@_cssFilter[_methodName] arg0, arg1

					do @_scheduleFiltersUpdate

					@

			else if method.length is 3

				ClassPrototype[_methodName] = (arg0, arg1, arg2) ->

					@_cssFilter[_methodName] arg0, arg1, arg2

					do @_scheduleFiltersUpdate

					@

			else if method.length is 4

				ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3) ->

					@_cssFilter[_methodName] arg0, arg1, arg2, arg3

					do @_scheduleFiltersUpdate

					@

			else if method.length is 5

				ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3, arg4) ->

					@_cssFilter[_methodName] arg0, arg1, arg2, arg3, arg4

					do @_scheduleFiltersUpdate

					@

			else

				throw Error "Methods with more than 5 args are not supported."

	Filters_