MethodChain = require '../../MethodChain/MethodChain'

module.exports = class Chain_

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

	_eventEnabledMethod: (args, runCallback) ->

		fn = args[0] ? null

		if fn

			runCallback =>

				fn.apply @, arguments

			return @

		else

			_interface = @_getNewInterface()

			runCallback =>

				@_getMethodChain().run _interface, @

			return _interface