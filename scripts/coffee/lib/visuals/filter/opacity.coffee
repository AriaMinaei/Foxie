if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	opacity = 

		toCss: (amount) ->

			"opacity(#{amount}%)"