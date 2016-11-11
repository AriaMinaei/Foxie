css = require '../../../../utility/css'

module.exports = class Typography_

	__initMixinTypography: ->

		@_type =

			face: Typography_.defaultFace

			size: Typography_.defaultSize

			color: Typography_.defaultColor

		@_sizeSet = no

		return

	_getSize: ->

		unless @_sizeSet

			@_type.size = parseFloat(getComputedStyle(@node).fontSize)

			@_sizeSet = yes

		@_type.size

	_initTypography: ->

		do @setSize
		do @setFace
		do @setColor

	setFace: (face) ->

		unless face

			@_type.face = Typography_.defaultFace

		else

			@_type.face = face

		do @_applyFace

		@

	_applyFace: ->

		@_styles.fontFamily = @_type.face

		@

	setSize: (size) ->

		unless size

			@_type.size = Typography_.defaultSize

		else

			@_type.size = size

		do @_applySize

		@

	_applySize: ->

		@_styles.fontSize = @_type.size + 'px'

		@

	setColor: (r, g, b) ->

		if arguments.length is 0

			@_type.color = Typography_.defaultColor

		else

			@_type.color = css.rgb(r, g, b)

		do @_applyColor

		@

	_applyColor: ->

		@_styles.color = @_type.color

		do @_applyStroke

		@

	_applyStroke: ->

		if Typography_.needsTextStroke() and @_getSize() < 50



			@_styles.webkitTextStroke = '1.5 ' + @_type.color

		@

	@defaultFace = '"HelveticaNeueLT Std Thin"'

	@setDefaultFace: (face = "HelveticaNeueLT Std Thin") ->

		@defaultFace = face

	@defaultSize = 36

	@setDefaultSize: (size = 36) ->

		@defaultSize = size

	@defaultColor = css.rgb(255, 255, 255)

	@setDefaultColor: (r, g, b) ->

		if arguments.length is 0

			@defaultColor = css.rgb(255, 255, 255)

		@defaultColor = css.rgb(r, g, b)

	# As long as chrome hasn't implemented DirectWrite, text won't look
	# its best on windows. This function will tell you if you need to
	# apply a -webkit-text-stroke to make text look a bit smoother on
	# chrome/win.
	@needsTextStroke: do ->

		_needsTextStroke = null

		->

			if _needsTextStroke is null

				if navigator.appVersion.indexOf('Chrome') isnt -1 and navigator.appVersion.indexOf('Windows') isnt -1

					_needsTextStroke = yes

				else

					_needsTextStroke = no

			_needsTextStroke