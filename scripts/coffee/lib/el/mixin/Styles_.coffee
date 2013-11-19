StyleSetter = require './styleSetter/StyleSetter'
Transitioner = require './transitioner/Transitioner'
timing = require '../../timing'

module.exports = class Styles

	__initMixinHasStyles: ->

		@_styleSetter = new StyleSetter @

		@_transitioner = new Transitioner @

		@fill = @_styleSetter.fill

		@_styleInterface = @_styleSetter

		@_updaterDeployed = no

		@_shouldUpdate = no

		@_updaterCallback = @_getNewUpdaterCallback()

		@_lastTimeUpdated = 0

		return

	_getNewUpdaterCallback: ->

		(t) => @_doUpdate t

	_scheduleUpdate: ->

		@_shouldUpdate = yes

		do @_deployUpdater

		return

	_deployUpdater: ->

		return if @_updaterDeployed

		@_updaterDeployed = yes

		timing.afterEachFrame @_updaterCallback

	_undeployUpdater: ->

		return unless @_updaterDeployed

		@_updaterDeployed = no

		timing.cancelAfterEachFrame @_updaterCallback

	_doUpdate: (t) ->

		unless @_shouldUpdate

			if t - @_lastTimeUpdated > 100

				do @_undeployUpdater

			return

		@_lastTimeUpdated = t

		@_shouldUpdate = no

		do @_transitioner._updateTransition

		do @_styleSetter._updateTransforms

		do @_styleSetter._updateFilters

		return

	__clonerForHasStyles: (newEl) ->

		newEl._styleSetter = @_styleSetter.clone newEl
		newEl.fill = newEl._styleSetter.fill
		newEl._transitioner = @_transitioner.clone newEl

		newEl._updaterDeployed = no

		newEl._shouldUpdate = no

		newEl._updaterCallback = newEl._getNewUpdaterCallback()

		newEl._lastTimeUpdated

		if @_styleInterface is @_styleSetter

			newEl._styleInterface = newEl._styleSetter

		else

			newEl._styleInterface = newEl._transitioner

		return

	__quitterForHasStyles: ->

		do @_undeployUpdater

	enableTransition: (duration) ->

		# console.log 'enable'

		@_styleInterface = @_transitioner

		@_transitioner.enable duration

		@

	disableTransition: ->

		@_styleInterface = @_styleSetter

		do @_transitioner.disable

		@

	trans: (duration) -> @enableTransition duration

	noTrans: -> do @disableTransition

	ease: (funcNameOrFirstNumOfCubicBezier, secondNum, thirdNum, fourthNum) ->

		@_transitioner.ease funcNameOrFirstNumOfCubicBezier, secondNum, thirdNum, fourthNum

		@

ClassPrototype = Styles.prototype

for methodName, method of Transitioner.prototype

	continue unless method instanceof Function

	continue if ClassPrototype[methodName]?

	continue if methodName[0] is '_'

	continue if methodName.substr(0, 3) is 'get'

	do ->

		_methodName = methodName

		if method.length is 0

			ClassPrototype[_methodName] = ->

				# This is more performant than method.apply()
				#
				# Argument splats won't work here though.
				@_styleInterface[_methodName]()

				@

		else if method.length is 1

			ClassPrototype[_methodName] = (arg0) ->

				@_styleInterface[_methodName] arg0

				@

		else if method.length is 2

			ClassPrototype[_methodName] = (arg0, arg1) ->

				@_styleInterface[_methodName] arg0, arg1

				@

		else if method.length is 3

			ClassPrototype[_methodName] = (arg0, arg1, arg2) ->

				@_styleInterface[_methodName] arg0, arg1, arg2

				@

		else if method.length is 4

			ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3) ->

				@_styleInterface[_methodName] arg0, arg1, arg2, arg3

				@

		else if method.length is 5

			ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3, arg4) ->

				@_styleInterface[_methodName] arg0, arg1, arg2, arg3, arg4

				@

		else

			throw Error "Methods with more than 5 args are not supported."

for methodName, method of StyleSetter.prototype

	continue unless method instanceof Function

	continue if ClassPrototype[methodName]?

	continue if methodName[0] is '_'

	continue if methodName.substr(0, 3) is 'get'

	do ->

		_methodName = methodName

		if method.length is 0

			ClassPrototype[_methodName] = ->

				# This is more performant than method.apply()
				#
				# Argument splats won't work here though.
				@_styleSetter[_methodName]()

				@

		else if method.length is 1

			ClassPrototype[_methodName] = (arg0) ->

				@_styleSetter[_methodName] arg0

				@

		else if method.length is 2

			ClassPrototype[_methodName] = (arg0, arg1) ->

				@_styleSetter[_methodName] arg0, arg1

				@

		else if method.length is 3

			ClassPrototype[_methodName] = (arg0, arg1, arg2) ->

				@_styleSetter[_methodName] arg0, arg1, arg2

				@

		else if method.length is 4

			ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3) ->

				@_styleSetter[_methodName] arg0, arg1, arg2, arg3

				@

		else if method.length is 5

			ClassPrototype[_methodName] = (arg0, arg1, arg2, arg3, arg4) ->

				@_styleSetter[_methodName] arg0, arg1, arg2, arg3, arg4

				@

		else

			throw Error "Methods with more than 5 args are not supported."

Styles