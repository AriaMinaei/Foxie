module.exports = translation =

	toPlainCss: (x, y, z) ->

		if -0.00001 < x < 0.00001

			x = 0


		if -0.00001 < y < 0.00001

			y = 0


		if -0.00001 < z < 0.00001

			z = 0

		"translate3d(#{x}px, #{y}px, #{z}px) "

	setTo: (b, x, y, z) ->

		b[12] = x
		b[13] = y
		b[14] = z

		b

	applyTo: (b, x, y, z) ->

		b[12] = x * b[0]  +  y * b[4]  +  z * b[8]  +  b[12]
		b[13] = x * b[1]  +  y * b[5]  +  z * b[9]  +  b[13]
		b[14] = x * b[2]  +  y * b[6]  +  z * b[10] +  b[14]
		b[15] = x * b[3]  +  y * b[7]  +  z * b[11] +  b[15]

		b