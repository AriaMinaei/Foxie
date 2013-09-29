if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	saturate = 

		toCss: (amount) ->

			"saturate(#{amount}%)"