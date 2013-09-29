if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	blur = 

		toCss: (radius) ->

			"blur(#{radius}px)"