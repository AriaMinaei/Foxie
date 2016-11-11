module.exports = class Fill_

	__initMixinFill: ->

		@_fromFill =

			opacity: null

		@_toFill =

			opacity: null

		@_currentFill = @el._styleSetter._fill

		return

	__clonerForFill: (newTransitioner) ->

		newTransitioner._currentFill = newTransitioner.el._styleSetter._fill

		return

	_adjustFromValuesForFill: ->

		@_fromFill.opacity = @_currentFill.opacity

		return

	_disableTransitionForFill: ->

		@_toFill.opacity = @_currentFill.opacity

		@_needsUpdate.opacity = no

		return

	_updateTransitionForFill: (progress) ->

		if @_needsUpdate.opacity

			@_updateOpacity progress

		return

	setOpacity: (d) ->

		@_toFill.opacity = d

		@_needsUpdate.opacity = yes

		do @_update

		@

	adjustOpacity: (d) ->

		@_toFill.opacity = @_currentFill.opacity + d

		@_needsUpdate.opacity = yes

		do @_update

		@

	_updateOpacity: (progress) ->

		@_styleSetter.setOpacity (

			@_fromFill.opacity +

			(@_toFill.opacity - @_fromFill.opacity) * progress

		)

		return