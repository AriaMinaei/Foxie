define [
	'./mixin/Generals_'
	'./mixin/Layout_'
	'./mixin/Fill_'
	'./mixin/Typography_'
	'./mixin/Transforms_'
	'./mixin/Filters_'
	'../../../utility/object'
	'../../../utility/classic'
], (Generals_, Layout_, Fill_, Typography_, Transforms_, Filters_, object, classic) ->

	classic.mix Generals_, Layout_, Fill_, Typography_, Transforms_, Filters_, class StyleSetter

		constructor: (@el) ->

			@node = @el.node

			@_styles = @node.style

			StyleSetter.__initMixinsFor @

		_scheduleUpdate: ->

			do @el._scheduleUpdate

		clone: (el) ->

			newObj = Object.create @constructor::

			newObj.el = el
			newObj.node = el.node
			newObj._styles = el.node.style

			StyleSetter.__applyClonersFor @, [newObj]

			for key of @

				continue if newObj[key] isnt undefined

				if @hasOwnProperty key

					newObj[key] = object.clone @[key], yes

			newObj