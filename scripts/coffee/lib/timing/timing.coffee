{array} = require 'utila'
timeoutPool = require './pool/timeout'
intervalPool = require './pool/interval'

getTime = do ->

	if performance? and performance.now?

		return -> performance.now()

	else

		return Date.now() - 1372763687107

_nextFrame = do ->

	return window.requestAnimationFrame if window.requestAnimationFrame

	return window.mozRequestAnimationFrame if window.mozRequestAnimationFrame

	return window.webkitRequestAnimationFrame if window.webkitRequestAnimationFrame

_cancelNextFrame = do ->

	return window.cancelAnimationFrame if window.cancelAnimationFrame

	return window.mozCancelAnimationFrame if window.mozCancelAnimationFrame

	return window.webkitCancelAnimationFrame if window.webkitCancelAnimationFrame

module.exports = timing =

	getTime: getTime

	time: 0

	timeInMs: 0

	speed: 1

	_toCallOnNextTick: []

	_nextTickTimeout: null

	nextTick: (fn) ->

		timing._toCallOnNextTick.push fn

		unless timing._nextTickTimeout

			timing._nextTickTimeout = setTimeout =>

				do timing._callTick

			, 0

		null

	_callTick: ->

		return if timing._toCallOnNextTick.length < 1

		timing._nextTickTimeout = null

		toCallNow = timing._toCallOnNextTick

		timing._toCallOnNextTick = []

		for fn in toCallNow

			do fn

		null

	_toCallLaterAfterFrame: []

	afterFrame: (fn) ->

		timing._toCallLaterAfterFrame.push fn

		null

	_callFramesScheduledForAfterFrame: (t) ->

		return if timing._toCallLaterAfterFrame.length < 1

		loop

			return if timing._toCallLaterAfterFrame.length < 1

			toCall = timing._toCallLaterAfterFrame

			timing._toCallLaterAfterFrame = []

			for fn in toCall

				fn t

		null

	_toCallOnFrame: []

	frame: (fn) ->

		timing._toCallOnFrame.push fn

		null

	cancelFrame: (fn) ->

		array.pluckOneItem timing._toCallOnFrame, fn

		null

	_callFramesScheduledForFrame: (t) ->

		return if timing._toCallOnFrame.length < 1

		toCallNow = timing._toCallOnFrame

		timing._toCallOnFrame = []

		for fn in toCallNow

			fn t

		null

	_toCallOnFrames: []

	_toCancelCallingOnFrame: []

	frames: (fn) ->

		timing._toCallOnFrames.push fn

		null

	cancelFrames: (fn) ->

		timing._toCancelCallingOnFrame.push fn

		null

	_callFramesScheduledForFrames: (t) ->

		return if timing._toCallOnFrames.length < 1

		for toCancel in timing._toCancelCallingOnFrame

			array.pluckOneItem timing._toCallOnFrames, toCancel

		timing._toCancelCallingOnFrame.length = 0

		for fn in timing._toCallOnFrames

			fn t

		return

	_toCallAfterFrames: []

	_toCancelCallingAfterFrames: []

	afterFrames: (fn) ->

		timing._toCallAfterFrames.push fn

		null

	cancelAfterFrames: (fn) ->

		timing._toCancelCallingAfterFrames.push fn

		null

	_callAfterFrames: (t) ->

		return if timing._toCallAfterFrames.length < 1

		for toCancel in timing._toCancelCallingAfterFrames

			array.pluckOneItem timing._toCallAfterFrames, toCancel

		timing._toCancelCallingAfterFrames.length = 0

		for fn in timing._toCallAfterFrames

			fn t

		null

	__shouldInjectCallItem: (itemA, itemB, itemToInject) ->

		unless itemA?

			return yes if itemToInject.time <= itemB.time

			return no

		unless itemB?

			return yes if itemA.time <= itemToInject.time

			return no

		return yes if itemA.time <= itemToInject.time <= itemB.time

		return no

	_waitCallbacks: []

	wait: (ms, fn) ->

		callTime = timing.timeInMs + ms + 8

		item = timeoutPool.give callTime, fn

		array.injectByCallback timing._waitCallbacks, item, timing.__shouldInjectCallItem

		null

	_callWaiters: (t) ->

		return if timing._waitCallbacks.length < 1

		loop

			return if timing._waitCallbacks.length < 1

			item = timing._waitCallbacks[0]

			return if item.time > timing.timeInMs

			timeoutPool.take item

			timing._waitCallbacks.shift()

			item.fn t

		null

	_intervals: []

	_toRemoveFromIntervals: []

	every: (ms, fn) ->

		timing._intervals.push intervalPool.give ms, timing.timeInMs, 0, fn

		null

	cancelEvery: (fn) ->

		timing._toRemoveFromIntervals.push fn

		null

	_callIntervals: ->

		return if timing._intervals.length < 1

		t = timing.timeInMs

		for fnToRemove in timing._toRemoveFromIntervals

			array.pluckByCallback timing._intervals, (item) ->

				return yes if item.fn is fnToRemove
				return no

		for item in timing._intervals

			properTimeToCall = item.from + (item.timesCalled * item.every) + item.every

			if properTimeToCall <= t

				item.fn t

				item.timesCalled++

		return

	_theLoop: (t) ->

		t = t * timing.speed

		_nextFrame timing._theLoop

		timing.time = t

		t = parseInt t

		timing.timeInMs = t

		timing._callFramesScheduledForFrame t

		timing._callFramesScheduledForFrames t

		timing._callAfterFrames t

		timing._callFramesScheduledForAfterFrame t

		timing._callWaiters t

		timing._callIntervals t

		null

	start: ->

		_nextFrame timing._theLoop

		null

timing.dontStart = do ->

	frame = _nextFrame ->

		timing.start()

	dontStart = ->

		_cancelNextFrame frame

timing