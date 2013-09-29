if typeof define isnt 'function' then define = require('amdefine')(module)

define ->

	hueRotate = 

		toCss: (angle) ->

			"hue-rotate(#{angle}deg)"