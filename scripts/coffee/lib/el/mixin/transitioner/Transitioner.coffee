define [
	'./mixin/Fill_'
	'./mixin/Transforms_'
	'../../../timing/timing'
	'../../../utility/object'
	'../../../visuals/animation/easing'
	'../../../utility/classic'
], (Fill_, Transforms_, timing, object, easing, classic) ->

	classic.mix Fill_, Transforms_, class Transitioner

		constructor: (@el) ->

			@_styleSetter = @el._styleSetter

			@_enabled = no

			@_duration = 1000

			@_startTime = 0

			Transitioner.__initMixinsFor @

			@_needsUpdate =

				transformMovement: no
				transformRotation: no
				transformScale: no
				transformPerspective: no
				transformLocalMovement: no
				opacity: no

			@_shouldUpdate = no

			@ease 'cubic.easeOut'

		ease: (funcNameOrFirstNumOfCubicBezier, secondNum, thirdNum, fourthNum) ->

			@_easing = easing.get.apply easing, arguments

			@

		clone: (el) ->

			newObj = Object.create @constructor::

			newObj.el = el

			newObj._startTime = new Int32Array 1
			newObj._startTime[0] = 0

			newObj._styleSetter = el._styleSetter

			newObj._needsUpdate =

				transformMovement: no
				transformRotation: no
				transformScale: no
				transformPerspective: no
				transformLocalMovement: no
				opacity: no

			Transitioner.__applyClonersFor @, [newObj]

			for key of @

				continue if newObj[key] isnt undefined

				if @hasOwnProperty key

					newObj[key] = object.clone @[key], yes

			newObj

		enable: (duration) ->

			@_enabled = yes

			@_duration = duration

			@

		disable: ->

			@_enabled = no

			do @_stop

			@

		_stop: ->

			@_shouldUpdate = no

			do @_disableTransitionForTransforms
			do @_disableTransitionForFill

			return

		_update: ->

			return if @_startTime is timing.timeInMs

			do @_startOver

			return

		_startOver: ->

			@_startTime = timing.timeInMs

			do @_adjustFromValues

			@_shouldUpdate = yes

			do @_scheduleUpdate

		_adjustFromValues: ->

			do @_adjustFromValuesForTransforms

			do @_adjustFromValuesForFill

			@

		_scheduleUpdate: ->

			do @el._scheduleUpdate

		_updateTransition: ->

			return if not @_enabled or not @_shouldUpdate

			@_updateForTime timing.timeInMs

		_updateForTime: (t) ->

			ellapsed = (t - @_startTime)

			progress = ellapsed / @_duration

			if progress >= 1

				progress = 1

			else

				do @_scheduleUpdate

			progress = @_ease progress

			@_updateByProgress progress

			if progress is 1

				do @_stop

			return

		_updateByProgress: (progress) ->

			@_updateTransitionForTransforms progress

			@_updateTransitionForFill progress

			null

		_ease: (progress) ->

			@_easing progress