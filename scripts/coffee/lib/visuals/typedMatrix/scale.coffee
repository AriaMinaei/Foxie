module.exports = scale =

	toPlainCss: (x, y, z) ->

		if -0.00001 < x < 0.00001

			x = 0


		if -0.00001 < y < 0.00001

			y = 0


		if -0.00001 < z < 0.00001

			z = 0

		"scale3d(#{x}, #{y}, #{z}) "

	applyTo: (b, x, y, z) ->

		b[0] *= x
		b[1] *= x
		b[2] *= x
		b[3] *= x

		b[4] *= y
		b[5] *= y
		b[6] *= y
		b[7] *= y

		b[9]  *= z
		b[10] *= z
		b[11] *= z
		b[12] *= z

		b