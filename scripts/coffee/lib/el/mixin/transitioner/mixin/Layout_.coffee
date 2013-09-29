define ->

	class Layout_

		__initMixinLayout: ->

			@_dimsFrom =

				width: null

				height: null

			@_dimsTo =

				width: null

				height: null

		setWidth: (w) ->

			@_dimsTo.width = w

			@_dimsFrom.width = @_styleSetter._dims.width

			@_addUpdater '_updateWidth'

			@

		_updateWidth: (progress) ->

			@_styleSetter.setWidth @_dimsFrom.width +

				( (@_dimsTo.width - @_dimsFrom.width) * progress )

		setHeight: (h) ->

			@_dimsTo.height = h

			@_dimsFrom.height = @_styleSetter._dims.height

			@_addUpdater '_updateHeight'

			@

		_updateHeight: (progress) ->

			@_styleSetter.setHeight @_dimsFrom.height +

				( (@_dimsTo.height - @_dimsFrom.width) * progress )