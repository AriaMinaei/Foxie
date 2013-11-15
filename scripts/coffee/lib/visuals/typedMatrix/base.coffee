module.exports = base =

	identity: ->

		a = new Float64Array 16

		a[0] = 1
		a[1] = 0
		a[2] = 0
		a[3] = 0

		a[4] = 0
		a[5] = 1
		a[6] = 0
		a[7] = 0

		a[8] = 0
		a[9] = 0
		a[10] = 1
		a[11] = 0

		a[12] = 0
		a[13] = 0
		a[14] = 0
		a[15] = 1

		a

	setIdentity: (a) ->

		a[0] = 1
		a[1] = 0
		a[2] = 0
		a[3] = 0

		a[4] = 0
		a[5] = 1
		a[6] = 0
		a[7] = 0

		a[8] = 0
		a[9] = 0
		a[10] = 1
		a[11] = 0

		a[12] = 0
		a[13] = 0
		a[14] = 0
		a[15] = 1

		a

	css2Array: (s) ->

		# Is it a matrix3d?
		if s.substr(8, 1) is '('

			# Remove the 'matrix3d(' and ')'
			s = s.substr(9, s.length - 10)
			result = s.split(', ').map(parseFloat)

		# Or a matrix?
		else if s.substr(6, 1) is '('

			s = s.substr(7, s.length - 8)
			temp = s.split(', ').map(parseFloat)
			result = [
				temp[0],
				temp[1],
				0, 0,

				temp[2],
				temp[3],
				0, 0,

				0, 0, 1, 0,

				temp[4],
				temp[5],
				0, 1
			]

		else if s[0] is 'n'

			# none
			result = identity()

		else

			throw Error 'Unkown matrix format'

		result

	fromCss: (s) ->

		base.fromArray base.css2Array s

	fromArray: (a) ->

		n = new Float64Array 16

		n[0] = a[0]
		n[1] = a[1]
		n[2] = a[2]
		n[3] = a[3]

		n[4] = a[4]
		n[5] = a[5]
		n[6] = a[6]
		n[7] = a[7]

		n[8] = a[8]
		n[9] = a[9]
		n[10] = a[10]
		n[11] = a[11]

		n[12] = a[12]
		n[13] = a[13]
		n[14] = a[14]
		n[15] = a[15]

		n


	toCss2: (a) ->

		'matrix3d(' +
			m[0] + ', ' +
			m[1] + ', ' +
			m[2] + ', ' +
			m[3] + ', ' +

			m[4] + ', ' +
			m[5] + ', ' +
			m[6] + ', ' +
			m[7] + ', ' +

			m[8] + ', ' +
			m[9] + ', ' +
			m[10] + ', ' +
			m[11] + ', ' +

			m[12] + ', ' +
			m[13] + ', ' +
			m[14] + ', ' +
			m[15] + ')'

	toCss: (m) ->

		'matrix3d(' +
			@_toCssNumber(m[0]) + ', ' +
			@_toCssNumber(m[1]) + ', ' +
			@_toCssNumber(m[2]) + ', ' +
			@_toCssNumber(m[3]) + ', ' +

			@_toCssNumber(m[4]) + ', ' +
			@_toCssNumber(m[5]) + ', ' +
			@_toCssNumber(m[6]) + ', ' +
			@_toCssNumber(m[7]) + ', ' +

			@_toCssNumber(m[8]) + ', ' +
			@_toCssNumber(m[9]) + ', ' +
			@_toCssNumber(m[10]) + ', ' +
			@_toCssNumber(m[11]) + ', ' +

			@_toCssNumber(m[12]) + ', ' +
			@_toCssNumber(m[13]) + ', ' +
			@_toCssNumber(m[14]) + ', ' +
			@_toCssNumber(m[15]) + ')'

	_toCssNumber: (num) ->

		if -0.000001 < num < 0.000001

			return 0

		else

			return num

	multiply: (b, a) ->

		c = new Float64Array 16


		c[0]  = a[0] * b[0]   +  a[1]  * b[4]  +  a[2]  * b[8]  +  a[3] * b[12]
		c[1]  = a[0] * b[1]   +  a[1]  * b[5]  +  a[2]  * b[9]  +  a[3] * b[13]
		c[2]  = a[0] * b[2]   +  a[1]  * b[6]  +  a[2]  * b[10]  +  a[3] * b[14]
		c[3]  = a[0] * b[3]   +  a[1]  * b[7]  +  a[2]  * b[11]  +  a[3] * b[15]

		c[4]  = a[4] * b[0]   +  a[5]  * b[4]  +  a[6]  * b[8]  +  a[7] * b[12]
		c[5]  = a[4] * b[1]   +  a[5]  * b[5]  +  a[6]  * b[9]  +  a[7] * b[13]
		c[6]  = a[4] * b[2]   +  a[5]  * b[6]  +  a[6]  * b[10]  +  a[7] * b[14]
		c[7]  = a[4] * b[3]   +  a[5]  * b[7]  +  a[6]  * b[11]  +  a[7] * b[15]

		c[8]  = a[8] * b[0]   +  a[9]  * b[4]  +  a[10] * b[8]  +  a[11] * b[12]
		c[9]  = a[8] * b[1]   +  a[9]  * b[5]  +  a[10] * b[9]  +  a[11] * b[13]
		c[10] = a[8] * b[2]   +  a[9]  * b[6]  +  a[10] * b[10]  +  a[11] * b[14]
		c[11] = a[8] * b[3]   +  a[9]  * b[7]  +  a[10] * b[11]  +  a[11] * b[15]

		c[12] = a[12] * b[0]  +  a[13] * b[4]  +  a[14] * b[8]  +  a[15] * b[12]
		c[13] = a[12] * b[1]  +  a[13] * b[5]  +  a[14] * b[9]  +  a[15] * b[13]
		c[14] = a[12] * b[2]  +  a[13] * b[6]  +  a[14] * b[10]  +  a[15] * b[14]
		c[15] = a[12] * b[3]  +  a[13] * b[7]  +  a[14] * b[11]  +  a[15] * b[15]


	toArray: (m) ->

		[
			m[0], m[1], m[2], m[3],
			m[4], m[5], m[6], m[7],
			m[8], m[9], m[10], m[11],
			m[12], m[13], m[14], m[15]
		]