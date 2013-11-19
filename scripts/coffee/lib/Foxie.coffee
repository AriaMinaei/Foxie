Chain_ = require './el/mixin/Chain_'
timing = require './timing'
Styles_ = require './el/mixin/Styles_'
Timing_ = require './el/mixin/Timing_'
lazyValues = require './utility/lazyValues'
Interactions_ = require './el/mixin/Interactions_'
{classic, object, array} = require 'utila'

Timing = require 'raf-timing'

module.exports = classic.mix Styles_, Chain_, Timing_, Interactions_, class Foxie

	self = @

	@Timing: Timing

	@_defaultContainer: null

	@_getDefaultContainer: ->

		if @_defaultContainer?

			return @_defaultContainer

		else

			return document.body

	@_: (fn) ->

		lazyValues.returnLazily fn

	constructor: (@node) ->

		unless @node instanceof Element

			throw Error "node must be an HTML element."

		if not @_shouldCloneInnerHTML?

			@_shouldCloneInnerHTML = no

		self.__initMixinsFor @

		@_beenAppended = no

		@_parent = null

		@_children = []

		timing.nextTick =>

			if not @_beenAppended

				if not @node.parentselfement? and @node.tagName isnt 'BODY'

					@putIn self._getDefaultContainer()

				else

					@_beenAppended = yes

	clone: (newself = Object.create @constructor::) ->

		@_doUpdate()

		# Adding the node
		newNode = @node.cloneNode()
		newself.node = newNode
		newself._children = []

		# Cloning the children
		if @_shouldCloneInnerHTML

			newself.node.innerHTML = @node.innerHTML

		else

			for child in @_children

				child.clone().putIn newself

		# Deciding on the parent
		newself._parent = null

		if @_parent?

			parent = @_parent

		else

			parent = @node._parent ? @node.parentselfement ? null

		newself._beenAppended = no

		timing.afterFrame =>

			if not newself._beenAppended

				newself.putIn parent

			return

		self.__applyClonersFor @, [newself]

		for key, val of @

			continue if newself[key] isnt undefined

			if @hasOwnProperty key

				newself[key] = object.clone val, yes

		newself

	_notYourChildAnymore: (el) ->

		unless el instanceof self

			throw Error "`el` must be an instance of `self`"

		array.pluckItem @_children, el

		@

	putIn: (el = self._getDefaultContainer()) ->

		if @_parent?

			@_parent._notYourChildAnymore @

		if el instanceof self

			el._append @
			@_parent = el

		else

			el.appendChild @node
			@_parent = null

		@_beenAppended = yes

		@

	takeOutOfParent: ->

		if @_parent?

			@_parent._notYourChildAnymore @

		@_parent = null

		@_beenAppended = no

		@

	beDefaultContainer: ->

		self._defaultContainer = @

		@

	_append: (el) ->

		if el instanceof self

			node = el.node
			@_children.push el

		else

			node = el

		@node.appendChild node

		@

	remove: ->

		if @_parent?

			@_parent._notYourChildAnymore @

		if @node.parentNode?

			@node.parentNode.removeChild @node

		null

	quit: ->

		p = @node.parentNode

		if p?

			p.removeChild @node

		for child in @_children

			child.quit()


		self.__applyQuittersFor @

		return

	each: (cb = null) ->

		if cb instanceof Function

			# I have to use this loop, since the children
			# might be put in another container
			i = 0
			child = null
			counter = -1

			loop

				counter++

				if child is @_children[i]

					i++

				child = @_children[i]

				break unless child?

				cb.call @, child, counter

			return @

		_interface = @_getNewInterface()

		els = @_children

		if els.length isnt 0

			timing.afterFrame =>

				for el in els

					@_getMethodChain().run _interface, el

				null

		return _interface