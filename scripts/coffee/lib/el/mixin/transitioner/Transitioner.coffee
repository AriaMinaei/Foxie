Fill_ = require './mixin/Fill_'
Transforms_ = require './mixin/Transforms_'
# Layout_ = require './mixin/Layout_'
timing = require '../../../timing'
easing = require 'timing-function'
{classic, object} = require 'utila'

module.exports = classic.mix Fill_, Transforms_, class Transitioner

	constructor: (@el) ->

		@_styleSetter = @el._styleSetter

		@_enabled = no

		@_duration = 1000

		@_startTime = -1

		Transitioner.__initMixinsFor @

		@_needsUpdate =

			transformMovement: no
			transformRotation: no
			transformScale: no
			transformPerspective: no
			transformLocalMovement: no
			transformRotate3d: no
			opacity: no
			# width: no
			# height: no
			# clip: no

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
			transformRotate3d: no
			# width: no
			# height: no
			opacity: no
			# clip: no

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
		# do @_disableTransitionForLayout

		return

	_update: ->

		return if @_startTime is timing.time

		do @_startOver

		return

	_startOver: ->

		@_startTime = timing.time

		do @_adjustFromValues

		@_shouldUpdate = yes

		do @_scheduleUpdate

	_adjustFromValues: ->

		do @_adjustFromValuesForTransforms

		do @_adjustFromValuesForFill

		# do @_adjustFromValuesForLayout

		@

	_scheduleUpdate: ->

		do @el._scheduleUpdate

	_updateTransition: ->

		return if not @_enabled or not @_shouldUpdate

		@_updateForTime timing.time

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

		# @_updateTransitionForLayout progress

		null

	_ease: (progress) ->

		@_easing progress