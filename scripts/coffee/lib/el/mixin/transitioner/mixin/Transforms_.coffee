Transformation = require 'Transformation'

module.exports = class Transforms_

	__initMixinTransforms: ->

		@_toMatrix = Transformation._emptyStack()

		@_fromMatrix = Transformation._emptyStack()

		@_currentMatrix = @el._styleSetter._transformer._current

	__clonerForTransforms: (newTransitioner) ->

		newTransitioner._currentMatrix = newTransitioner.el._styleSetter._transformer._current

		return

	_adjustFromValuesForTransforms: ->

		@_fromMatrix[0] = @_currentMatrix[0]
		@_fromMatrix[1] = @_currentMatrix[1]
		@_fromMatrix[2] = @_currentMatrix[2]

		@_fromMatrix[3] = @_currentMatrix[3]
		@_fromMatrix[4] = @_currentMatrix[4]
		@_fromMatrix[5] = @_currentMatrix[5]

		@_fromMatrix[6] = @_currentMatrix[6]

		@_fromMatrix[7] = @_currentMatrix[7]
		@_fromMatrix[8] = @_currentMatrix[8]
		@_fromMatrix[9] = @_currentMatrix[9]

		@_fromMatrix[10] = @_currentMatrix[10]
		@_fromMatrix[11] = @_currentMatrix[11]
		@_fromMatrix[12] = @_currentMatrix[12]

		@_fromMatrix[13] = @_currentMatrix[13]
		@_fromMatrix[14] = @_currentMatrix[14]
		@_fromMatrix[15] = @_currentMatrix[15]

		@

	_disableTransitionForTransforms: ->

		@_needsUpdate.transformMovement = no
		@_toMatrix[0] = @_currentMatrix[0]
		@_toMatrix[1] = @_currentMatrix[1]
		@_toMatrix[2] = @_currentMatrix[2]

		@_needsUpdate.transformScale = no
		@_toMatrix[3] = @_currentMatrix[3]
		@_toMatrix[4] = @_currentMatrix[4]
		@_toMatrix[5] = @_currentMatrix[5]

		@_needsUpdate.transformPerspective = no
		@_toMatrix[6] = @_currentMatrix[6]

		@_needsUpdate.transformRotation = no
		@_toMatrix[7] = @_currentMatrix[7]
		@_toMatrix[8] = @_currentMatrix[8]
		@_toMatrix[9] = @_currentMatrix[9]

		@_needsUpdate.transformLocalMovement = no
		@_toMatrix[10] = @_currentMatrix[10]
		@_toMatrix[11] = @_currentMatrix[11]
		@_toMatrix[12] = @_currentMatrix[12]

		@_needsUpdate.transformLocalRotation = no
		@_toMatrix[13] = @_currentMatrix[13]
		@_toMatrix[14] = @_currentMatrix[14]
		@_toMatrix[15] = @_currentMatrix[15]

		@

	_updateTransitionForTransforms: (progress) ->

		if @_needsUpdate.transformMovement

			@_updateMovement progress

		if @_needsUpdate.transformRotation

			@_updateRotation progress

		if @_needsUpdate.transformScale

			@_updateScale progress

		if @_needsUpdate.transformPerspective

			@_updatePerspective progress

		if @_needsUpdate.transformLocalMovement

			@_updateLocalMovement progress

		if @_needsUpdate.transformLocalRotation

			@_updateLocalRotation progress

		return

	_updateMovement: (progress) ->

		@_styleSetter.moveTo (
				@_fromMatrix[0] +
				((@_toMatrix[0] - @_fromMatrix[0]) * progress)
			),
			(
				@_fromMatrix[1] +
				((@_toMatrix[1] - @_fromMatrix[1]) * progress)
			),
			(
				@_fromMatrix[2] +
				((@_toMatrix[2] - @_fromMatrix[2]) * progress)
			)

		null

	_reportUpdateForMove: ->

		return if @_needsUpdate.transformMovement

		@_needsUpdate.transformMovement = yes

		@_toMatrix[0] = @_currentMatrix[0]
		@_toMatrix[1] = @_currentMatrix[1]
		@_toMatrix[2] = @_currentMatrix[2]

		return

	resetMovement: ->

		do @_reportUpdateForMove

		@_toMatrix[0] = 0
		@_toMatrix[1] = 0
		@_toMatrix[2] = 0

		do @_update

		@

	moveTo: (x, y, z) ->

		do @_reportUpdateForMove

		@_toMatrix[0] = x
		@_toMatrix[1] = y
		@_toMatrix[2] = z

		do @_update

		@

	moveXTo: (x) ->

		do @_reportUpdateForMove

		@_toMatrix[0] = x

		do @_update

		@

	moveYTo: (y) ->

		do @_reportUpdateForMove

		@_toMatrix[1] = y

		do @_update

		@

	moveZTo: (z) ->

		do @_reportUpdateForMove

		@_toMatrix[2] = z

		do @_update

		@

	move: (x, y, z) ->

		do @_reportUpdateForMove

		@_toMatrix[0] = @_currentMatrix[0] + x
		@_toMatrix[1] = @_currentMatrix[1] + y
		@_toMatrix[2] = @_currentMatrix[2] + z

		do @_update

		@

	moveX: (x) ->

		do @_reportUpdateForMove

		@_toMatrix[0] = @_currentMatrix[0] + x

		do @_update

		@

	moveY: (y) ->

		do @_reportUpdateForMove

		@_toMatrix[1] = @_currentMatrix[1] + y

		do @_update

		@

	moveZ: (z) ->

		do @_reportUpdateForMove

		@_toMatrix[2] = @_currentMatrix[2] + z

		do @_update

		@

	###
	Scale
	###

	_updateScale: (progress) ->

		@_styleSetter.scaleTo (
				@_fromMatrix[3] +
				((@_toMatrix[3] - @_fromMatrix[3]) * progress)
			),
			(
				@_fromMatrix[4] +
				((@_toMatrix[4] - @_fromMatrix[4]) * progress)
			),
			(
				@_fromMatrix[5] +
				((@_toMatrix[5] - @_fromMatrix[5]) * progress)
			)

		null

	_reportUpdateForScale: ->

		return if @_needsUpdate.transformScale

		@_needsUpdate.transformScale = yes

		@_toMatrix[3] = @_currentMatrix[3]
		@_toMatrix[4] = @_currentMatrix[4]
		@_toMatrix[5] = @_currentMatrix[5]

		return

	resetScale: ->

		do @_reportUpdateForScale

		@_toMatrix[3] = 1
		@_toMatrix[4] = 1
		@_toMatrix[5] = 1

		do @_update

		@

	scaleTo: (x, y, z) ->

		do @_reportUpdateForScale

		@_toMatrix[3] = x
		@_toMatrix[4] = y
		@_toMatrix[5] = z

		do @_update

		@

	scaleXTo: (x) ->

		do @_reportUpdateForScale

		@_toMatrix[3] = x

		do @_update

		@

	scaleYTo: (y) ->

		do @_reportUpdateForScale

		@_toMatrix[4] = y

		do @_update

		@

	scaleZTo: (z) ->

		do @_reportUpdateForScale

		@_toMatrix[5] = z

		do @_update

		@

	scale: (x, y, z) ->

		do @_reportUpdateForScale

		@_toMatrix[3] = @_currentMatrix[3] * x
		@_toMatrix[4] = @_currentMatrix[4] * y
		@_toMatrix[5] = @_currentMatrix[5] * z

		do @_update

		@

	scaleAllTo: (x) ->

		do @_reportUpdateForScale

		@_toMatrix[3] = @_toMatrix[4] = @_toMatrix[5] = x

		do @_update

		@

	scaleX: (x) ->

		do @_reportUpdateForScale

		@_toMatrix[3] = @_currentMatrix[3] * x

		do @_update

		@

	scaleY: (y) ->

		do @_reportUpdateForScale

		@_toMatrix[4] = @_currentMatrix[4] * y

		do @_update

		@

	scaleZ: (z) ->

		do @_reportUpdateForScale

		@_toMatrix[5] = @_currentMatrix[5] * z

		do @_update

		@

	_reportUpdateForPerspective: ->

		return if @_needsUpdate.transformPerspective

		@_needsUpdate.transformPerspective = yes

		@_toMatrix[6] = @_currentMatrix[6]

		return

	###
	Perspective
	###

	_updatePerspective: (progress) ->

		@_styleSetter.perspective (
				@_fromMatrix[6] +
				((@_toMatrix[6] - @_fromMatrix[6]) * progress)
			)

		null

	resetPerspective: ->

		do @_reportUpdateForPerspective

		@_toMatrix[6] = 0

		do @_update

		@

	perspective: (d) ->

		do @_reportUpdateForPerspective

		@_toMatrix[6] = d

		do @_update

		@

	###
	Rotation
	###

	_updateRotation: (progress) ->

		@_styleSetter.rotateTo (
				@_fromMatrix[7] +
				((@_toMatrix[7] - @_fromMatrix[7]) * progress)
			),
			(
				@_fromMatrix[8] +
				((@_toMatrix[8] - @_fromMatrix[8]) * progress)
			),
			(
				@_fromMatrix[9] +
				((@_toMatrix[9] - @_fromMatrix[9]) * progress)
			)

		null

	_reportUpdateForRotation: ->

		return if @_needsUpdate.transformRotation

		@_needsUpdate.transformRotation = yes

		@_toMatrix[7] = @_currentMatrix[7]
		@_toMatrix[8] = @_currentMatrix[8]
		@_toMatrix[9] = @_currentMatrix[9]

		return

	resetRotation: ->

		do @_reportUpdateForRotation

		@_toMatrix[7] = 0
		@_toMatrix[8] = 0
		@_toMatrix[9] = 0

		do @_update

		@

	rotateTo: (x, y, z) ->

		do @_reportUpdateForRotation

		@_toMatrix[7] = x
		@_toMatrix[8] = y
		@_toMatrix[9] = z

		do @_update

		@

	rotateXTo: (x) ->

		do @_reportUpdateForRotation

		@_toMatrix[7] = x

		do @_update

		@

	rotateYTo: (y) ->

		do @_reportUpdateForRotation

		@_toMatrix[8] = y

		do @_update

		@

	rotateZTo: (z) ->

		do @_reportUpdateForRotation

		@_toMatrix[9] = z

		do @_update

		@

	rotate: (x, y, z) ->

		do @_reportUpdateForRotation

		@_toMatrix[7] = @_currentMatrix[7] + x
		@_toMatrix[8] = @_currentMatrix[8] + y
		@_toMatrix[9] = @_currentMatrix[9] + z

		do @_update

		@

	rotateX: (x) ->

		do @_reportUpdateForRotation

		@_toMatrix[7] = @_currentMatrix[7] + x

		do @_update

		@

	rotateY: (y) ->

		do @_reportUpdateForRotation

		@_toMatrix[8] = @_currentMatrix[8] + y

		do @_update

		@

	rotateZ: (z) ->

		do @_reportUpdateForRotation

		@_toMatrix[9] = @_currentMatrix[9] + z

		do @_update

		@

	###
	LocalMovement
	###

	_updateLocalMovement: (progress) ->

		@_styleSetter.localMoveTo (
				@_fromMatrix[10] +
				((@_toMatrix[10] - @_fromMatrix[10]) * progress)
			),
			(
				@_fromMatrix[11] +
				((@_toMatrix[11] - @_fromMatrix[11]) * progress)
			),
			(
				@_fromMatrix[12] +
				((@_toMatrix[12] - @_fromMatrix[12]) * progress)
			)

		null

	_reportUpdateForLocalMovement: ->

		return if @_needsUpdate.transformLocalMovement

		@_needsUpdate.transformLocalMovement = yes

		@_toMatrix[10] = @_currentMatrix[10]
		@_toMatrix[11] = @_currentMatrix[11]
		@_toMatrix[12] = @_currentMatrix[12]

		return

	resetLocalMovement: ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[10] = 0
		@_toMatrix[11] = 0
		@_toMatrix[12] = 0

		do @_update

		@

	localMoveTo: (x, y, z) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[10] = x
		@_toMatrix[11] = y
		@_toMatrix[12] = z

		do @_update

		@

	localMoveXTo: (x) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[10] = x

		do @_update

		@

	localMoveYTo: (y) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[11] = y

		do @_update

		@

	localMoveZTo: (z) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[12] = z

		do @_update

		@

	localMove: (x, y, z) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[10] = @_currentMatrix[10] + x
		@_toMatrix[11] = @_currentMatrix[11] + y
		@_toMatrix[12] = @_currentMatrix[12] + z

		do @_update

		@

	localMoveX: (x) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[10] = @_currentMatrix[10] + x

		do @_update

		@

	localMoveY: (y) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[11] = @_currentMatrix[11] + y

		do @_update

		@

	localMoveZ: (z) ->

		do @_reportUpdateForLocalMovement

		@_toMatrix[12] = @_currentMatrix[12] + z

		do @_update

		@

	###
	Rotation
	###

	_updateLocalRotation: (progress) ->

		@_styleSetter.localRotateTo (
				@_fromMatrix[13] +
				((@_toMatrix[13] - @_fromMatrix[13]) * progress)
			),
			(
				@_fromMatrix[14] +
				((@_toMatrix[14] - @_fromMatrix[14]) * progress)
			),
			(
				@_fromMatrix[15] +
				((@_toMatrix[15] - @_fromMatrix[15]) * progress)
			)

		null

	_reportUpdateForLocalRotation: ->

		return if @_needsUpdate.transformLocalRotation

		@_needsUpdate.transformLocalRotation = yes

		@_toMatrix[13] = @_currentMatrix[13]
		@_toMatrix[14] = @_currentMatrix[14]
		@_toMatrix[15] = @_currentMatrix[15]

		return

	resetLocalRotation: ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[13] = 0
		@_toMatrix[14] = 0
		@_toMatrix[15] = 0

		do @_update

		@

	localRotateTo: (x, y, z) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[13] = x
		@_toMatrix[14] = y
		@_toMatrix[15] = z

		do @_update

		@

	localRotateXTo: (x) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[13] = x

		do @_update

		@

	localRotateYTo: (y) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[14] = y

		do @_update

		@

	localRotateZTo: (z) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[15] = z

		do @_update

		@

	localRotate: (x, y, z) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[13] = @_currentMatrix[13] + x
		@_toMatrix[14] = @_currentMatrix[14] + y
		@_toMatrix[15] = @_currentMatrix[15] + z

		do @_update

		@

	localRotateX: (x) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[13] = @_currentMatrix[13] + x

		do @_update

		@

	localRotateY: (y) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[14] = @_currentMatrix[14] + y

		do @_update

		@

	localRotateZ: (z) ->

		do @_reportUpdateForLocalRotation

		@_toMatrix[15] = @_currentMatrix[15] + z

		do @_update

		@

	resetAll: ->

		do @resetMovement
		do @resetScale
		do @resetPerspective
		do @resetRotation
		do @resetLocalMovement
		do @resetLocalRotation