if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	contrast = 

		toCss: (amount) ->

			"contrast(#{amount}%)"