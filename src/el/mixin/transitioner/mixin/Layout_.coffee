module.exports = class Layout_

	__initMixinLayout: ->

		@_fromLayout =

			width: null

			height: null

			clipLeft: 'auto'

			clipRight: 'auto'

			clipTop: 'auto'

			clipBottom: 'auto'

		@_toLayout =

			width: null

			height: null

			clipLeft: 'auto'

			clipRight: 'auto'

			clipTop: 'auto'

			clipBottom: 'auto'

		@_currentLayout = @el._styleSetter._layout

		return

	__clonerForLayout: (newTransitioner) ->

		newTransitioner._currentLayout = newTransitioner.el._styleSetter._layout

		return

	_adjustFromValuesForLayout: ->

		@_fromLayout.width = @_currentLayout.width
		@_fromLayout.height = @_currentLayout.height

		@_fromLayout.clipTop = @_currentLayout.clipTop
		@_fromLayout.clipRight = @_currentLayout.clipRight
		@_fromLayout.clipBottom = @_currentLayout.clipBottom
		@_fromLayout.clipLeft = @_currentLayout.clipLeft


		return

	_disableTransitionForLayout: ->

		@_toLayout.width = @_currentLayout.width
		@_toLayout.height = @_currentLayout.height

		@_toLayout.clipTop = @_currentLayout.clipTop
		@_toLayout.clipRight = @_currentLayout.clipRight
		@_toLayout.clipBottom = @_currentLayout.clipBottom
		@_toLayout.clipLeft = @_currentLayout.clipLeft

		@_needsUpdate.width = no
		@_needsUpdate.height = no
		@_needsUpdate.clip = no

		return

	_updateTransitionForLayout: (progress) ->

		if @_needsUpdate.width

			@_updateWidth progress

		if @_needsUpdate.height

			@_updateHeight progress

		if @_needsUpdate.clip

			@_updateClip progress

		return

	_updateClip: (progress) ->

		@_styleSetter.clip (

			@_fromLayout.clipTop +

				(@_toLayout.clipTop - @_fromLayout.clipTop) * progress),

			(@_fromLayout.clipRight +

				(@_toLayout.clipRight - @_fromLayout.clipRight) * progress),

			(@_fromLayout.clipBottom +

				(@_toLayout.clipBottom - @_fromLayout.clipBottom) * progress),

			(@_fromLayout.clipLeft +

				(@_toLayout.clipLeft - @_fromLayout.clipLeft) * progress)



		return

	_updateWidth: (progress) ->

		@_styleSetter.setWidth (

			@_fromLayout.width +

			(@_toLayout.width - @_fromLayout.width) * progress

		)

		return

	_updateHeight: (progress) ->

		@_styleSetter.setHeight (

			@_fromLayout.height +

			(@_toLayout.height - @_fromLayout.height) * progress

		)

		return

	setWidth: (d) ->

		@_toLayout.width = d

		@_needsUpdate.width = yes

		do @_update

		@

	setHeight: (d) ->

		@_toLayout.height = d

		@_needsUpdate.height = yes

		do @_update

		@

	clip: (t, r, b, l) ->

		@_toLayout.clipTop = t
		@_toLayout.clipRight = r
		@_toLayout.clipBottom = b
		@_toLayout.clipLeft = l

		@_needsUpdate.clip = yes

		do @_update

		@

	clipTop: (t) ->

		@_toLayout.clipTop = t

		@_needsUpdate.clip = yes

		do @_update

		@

	clipRight: (r) ->

		@_toLayout.clipRight = r

		@_needsUpdate.clip = yes

		do @_update

		@

	clipBottom: (b) ->

		@_toLayout.clipBottom = b

		@_needsUpdate.clip = yes

		do @_update

		@

	clipLeft: (l) ->

		@_toLayout.clipLeft = l

		@_needsUpdate.clip = yes

		do @_update

		@