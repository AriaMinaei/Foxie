if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	brightness = 

		toCss: (amount) ->

			"brightness(#{amount})"