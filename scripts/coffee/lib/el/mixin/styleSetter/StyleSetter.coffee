Generals_ = require './mixin/Generals_'
Layout_ = require './mixin/Layout_'
Fill_ = require './mixin/Fill_'
Typography_ = require './mixin/Typography_'
Transforms_ = require './mixin/Transforms_'
Filters_ = require './mixin/Filters_'
object = require '../../../utility/object'
classic = require '../../../utility/classic'

module.exports = classic.mix Generals_, Layout_, Fill_, Typography_, Transforms_, Filters_, class StyleSetter

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