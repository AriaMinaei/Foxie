define [
	'../../../../utility/css'
	'../tools/ColorHolder'
], (css, ColorHolder) ->

	class Fill_

		__initMixinFill: ->

			@fill = new ColorHolder @_getFillUpdater()

			@_fill =

				bgColor: 'none'

				color: 'inherit'

				border: 'none'

				opacity: 1

		__clonerForFill: (newStyleSetter) ->

			newStyleSetter.fill = @fill.clone newStyleSetter._getFillUpdater()

			return

		_getFillUpdater: ->

			=>

				do @_updateFill

				return

		_updateFill: ->

			@_styles.backgroundColor = @_fill.bgColor = @fill._color.toCss()

			@

		rotateFillHue: (amount) ->

			@_fill.bgColor.rotateHue amount

			@_styles.backgroundColor = @_fill.bgColor.toCss()

		setTextColor: (r, g, b) ->

			@_styles.color = @_fill.color = css.rgb r, g, b

			null

		makeHollow: ->

			@_styles.bgColor = @_fill.bgColor = 'transparent'

		texturize: (filename) ->

			addr = "./images/#{filename}"

			@_styles.background = 'url(' + addr + ')'

			@

		setTexturePosition: (x, y) ->

			@_styles.backgroundPosition = "#{x}px #{y}px"

			@

		setBorder: (thickness, r, g, b) ->

			unless thickness?

				@_styles.border = @_fill.border = 'none'

			else

				@_styles.border = @_fill.border = "#{thickness}px solid #{css.rgb(r, g, b)}"

			@

		removeBorder: ->

			@_styles.border = @_fill.border = 'none'

			@

		setOpacity: (d) ->

			@_styles.opacity = @_fill.opacity = d

			@

		adjustOpacity: (d) ->

			@_fill.opacity += d;

			@_styles.opacity = @_fill.opacity

			@