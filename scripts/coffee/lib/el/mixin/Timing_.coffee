array = require '../../utility/array'
timing = require '../../timing/timing'

module.exports = class Timing_

	__initMixinTiming: ->

		@_quittersForTiming = []

		null

	__clonerForTiming: (newEl) ->

		newEl._quittersForTiming = []

	__quitterForTiming: ->

		loop

			return if @_quittersForTiming.length < 1

			@_quittersForTiming.pop()()

		return

	_getMethodChain: ->

		unless @constructor.__methodChain?

			@constructor.__methodChain = new MethodChain

			for key, fn of @

				continue if key[0] is '_' or key is 'constructor'

				continue unless fn instanceof Function

				@constructor.__methodChain.addMethod key

		@constructor.__methodChain

	_getNewInterface: ->

		@_getMethodChain().getInterface()

	wait: (ms, rest...) ->

		@_eventEnabledMethod rest, (cb) =>

			timing.wait ms, =>

				cb.call @

	immediately: ->

		@_eventEnabledMethod arguments, (cb) =>

			timing.afterFrame =>

				cb.call @

	eachFrame: ->

		@_eventEnabledMethod arguments, (cb) =>

			startTime = new Int32Array 1
			startTime[0] = -1

			canceled = no

			canceler = =>

				return if canceled

				timing.cancelFrames theCallback

				array.pluckOneItem @_quittersForTiming, canceler

				canceled = yes

			@_quittersForTiming.push canceler

			theCallback = (t) =>

				if startTime[0] < 0

					startTime[0] = t

					elapsedTime = 0

				else

					elapsedTime = t - startTime[0]

				cb.call @, elapsedTime, canceler

				null

			timing.frames theCallback

	run: ->

		@_eventEnabledMethod arguments, (cb) =>

			cb.call @

		@

	every: (ms, args...) ->

		@_eventEnabledMethod args, (cb) =>

			canceled = no

			canceler = =>

				return if canceled

				timing.cancelEvery theCallback

				array.pluckOneItem @_quittersForTiming, canceler

				canceled = yes

			@_quittersForTiming.push canceler

			theCallback = =>

				cb.call @, canceler

			timing.every ms, theCallback

	everyAndNow: (ms, args...) ->

		@_eventEnabledMethod args, (cb) =>

			canceled = no

			canceler = =>

				return if canceled

				timing.cancelEvery theCallback

				array.pluckOneItem @_quittersForTiming, canceler

				canceled = yes

			@_quittersForTiming.push canceler

			theCallback = =>

				cb.call @, canceler

			timing.every ms, theCallback

			timing.afterFrame theCallback