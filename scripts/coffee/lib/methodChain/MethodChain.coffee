define [
	'./_Interface'
	'../utility/lazyValues'
], (_Interface, lazyValues) ->

	class MethodChain

		constructor: ->

			@_methods = {}

			@_Interface = class I extends _Interface

		addMethod: (name) ->

			@_Interface::[name] = ->

				@_queue.push

					method: name
					args: Array::slice.call arguments

				@
			@

		getInterface: ->

			new @_Interface

		run: (_interface, context) ->

			for item in _interface._queue

				context = context[item.method].apply context, lazyValues.getLazyValues(item.args)

			context