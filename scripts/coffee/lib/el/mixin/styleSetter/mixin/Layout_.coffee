define ->

	class Layout_

		__initMixinLayout: ->

			@_dims =

				width: null

				height: null

		setWidth: (w) ->

			@_dims.width = w

			@_styles.width = w + 'px'

			do @el._updateAxis

			@

		setHeight: (h) ->

			@_dims.height = h

			@_styles.height = h + 'px'

			do @el._updateAxis

			@