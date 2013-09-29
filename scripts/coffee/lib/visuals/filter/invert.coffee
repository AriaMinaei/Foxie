if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	invert = 

		toCss: (amount) ->

			"invert(#{amount}%)"