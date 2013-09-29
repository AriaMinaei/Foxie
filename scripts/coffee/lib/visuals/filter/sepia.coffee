if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	sepia = 

		toCss: (amount) ->

			"sepia(#{amount}%)"