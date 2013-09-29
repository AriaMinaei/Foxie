define ->

	# The color value holder, with some utility functions.
	#
	# Conversion functions almost based on https://github.com/mjijackson/mjijackson.github.com/blob/master/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript.txt
	# Thanks to @mjijackson
	class CSSColor

		constructor: (h, s, l) ->

			@h = h
			@s = s
			@l = l

		setHue: (deg) ->

			@h = deg / 360

			@

		rotateHue: (deg) ->

			deg /= 360

			@h = @h + deg

			@

		setSaturation: (amount) ->

			@s = amount / 100

			@

		saturate: (amount) ->

			@s += amount / 100

			@

		setLightness: (amount) ->

			@l = amount / 100

			@

		lighten: (amount) ->

			@l += amount / 100

			@

		toCss: ->

			h = Math.round @h * 360
			s = Math.round @s * 100
			l = Math.round @l * 100

			"hsl(#{h}, #{s}%, #{l}%)"

		fromHsl: (h, s, l) ->

			@h = h / 360
			@s = s / 100
			@l = l / 100

			@

		toRgb: ->

			r = 0
			g = 0
			b = 0

			if @s is 0

				r = g = b = @l # achromatic

			else

				q = (if @l < 0.5 then @l * (1 + @s) else @l + @s - @l * @s)

				p = 2 * @l - q

				r = CSSColor._hue2rgb(p, q, @h + 1 / 3)

				g = CSSColor._hue2rgb(p, q, @h)

				b = CSSColor._hue2rgb(p, q, @h - 1 / 3)

			[r * 255, g * 255, b * 255]

		fromRgb: (r, g, b) ->

			r /= 255
			g /= 255
			b /= 255

			max = Math.max r, g, b
			min = Math.min r, g, b

			h = 0
			s = 0

			l = (max + min) / 2

			unless max is min

				d = max - min

				s = (if l > 0.5 then d / (2 - max - min) else d / (max + min))

				switch max

					when r

						h = (g - b) / d + ((if g < b then 6 else 0))

					when g

						h = (b - r) / d + 2

					when b

						h = (r - g) / d + 4

				h /= 6

			@h = h
			@s = s
			@l = l

			@

		clone: ->

			new CSSColor @h, @s, @l

		@hsl: (h, s, l) ->

			new CSSColor h, s, l

		@rgb: (r, g, b) ->

			r /= 255
			g /= 255
			b /= 255

			max = Math.max r, g, b
			min = Math.min r, g, b

			h = 0
			s = 0

			l = (max + min) / 2

			unless max is min

				d = max - min

				s = (if l > 0.5 then d / (2 - max - min) else d / (max + min))

				switch max

					when r

						h = (g - b) / d + ((if g < b then 6 else 0))

					when g

						h = (b - r) / d + 2

					when b

						h = (r - g) / d + 4

				h /= 6

			new CSSColor h, s, l

		@_hue2rgb = (p, q, t) ->

			t += 1  if t < 0

			t -= 1  if t > 1

			return p + (q - p) * 6 * t  if t < 1 / 6

			return q  if t < 1 / 2

			return p + (q - p) * (2 / 3 - t) * 6  if t < 2 / 3

			p