module.exports = rotation =

	toPlainCss: (x, y, z) ->

		if -0.00001 < x < 0.00001

			x = 0


		if -0.00001 < y < 0.00001

			y = 0


		if -0.00001 < z < 0.00001

			z = 0

		"rotateX(#{x}rad) rotateY(#{y}rad) rotateZ(#{z}rad) "

	applyTo: (b, x, y, z) ->

		cosx = Math.cos x
		sinx = Math.sin x

		cosy = Math.cos y
		siny = Math.sin y

		cosz = Math.cos z
		sinz = Math.sin z


		# 0
		a0 = cosy * cosz
		# 1
		a1 = cosx * sinz + sinx * siny * cosz
		# 2
		a2 = sinx * sinz - cosx * siny * cosz

		# 4
		a4 = -cosy * sinz
		# 5
		a5 = cosx * cosz - sinx * siny * sinz
		# 6
		a6 = sinx * cosz + cosx * siny * sinz


		# 8
		a8 = siny
		# 9
		a9 = -sinx * cosy
		# 10
		a10 = cosx * cosy


		# console.log arguments

		# a = Rotation.components x, y, z

		b0 = b[0]
		b1 = b[1]
		b2 = b[2]
		b3 = b[3]

		b4 = b[4]
		b5 = b[5]
		b6 = b[6]
		b7 = b[7]

		b8 = b[8]
		b9 = b[9]
		b10 = b[10]
		b11 = b[11]


		b[0] = a0 * b0  +  a1 * b4  +  a2 * b8
		b[1] = a0 * b1  +  a1 * b5  +  a2 * b9
		b[2] = a0 * b2  +  a1 * b6  +  a2 * b10
		b[3] = a0 * b3  +  a1 * b7  +  a2 * b11

		b[4] = a4 * b0  +  a5 * b4  +  a6 * b8
		b[5] = a4 * b1  +  a5 * b5  +  a6 * b9
		b[6] = a4 * b2  +  a5 * b6  +  a6 * b10
		b[7] = a4 * b3  +  a5 * b7  +  a6 * b11

		b[8] = a8 * b0  +  a9 * b4  +  a10 * b8
		b[9] = a8 * b1  +  a9 * b5  +  a10 * b9
		b[10] = a8 * b2  +  a9 * b6  +  a10 * b10
		b[11] = a8 * b3  +  a9 * b7  +  a10 * b11

		b