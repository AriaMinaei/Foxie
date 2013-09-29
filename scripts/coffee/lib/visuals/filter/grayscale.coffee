if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	grayscale = 

		toCss: (amount) ->

			"grayscale(#{amount}%)"