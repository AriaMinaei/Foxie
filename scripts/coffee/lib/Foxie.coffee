Chain_ = require './el/mixin/Chain_'
timing = require './timing'
Styles_ = require './el/mixin/Styles_'
Timing_ = require './el/mixin/Timing_'
lazyValues = require './utility/lazyValues'
{classic, object, array} = require 'utila'

timing = require './timing'

module.exports = classic.mix Styles_, Chain_, Timing_, class Foxie

	self = @

	@_nameRx: /^[a-zA-Z\-\_]{1}[a-zA-Z0-9\-\_]*$/

	@timing: timing

	@_parseTag: (k) ->

		# validate
		if not k.match(/^[a-zA-Z0-9\#\-\_\.\[\]\"\'\=\,\s]+$/) or k.match(/^[0-9]+/)

			throw Error "cannot parse tag `#{k}`"

		attribs = {}

		parts =

			name: ''

			attribs: attribs

		# tag name
		if m = k.match /^([^\.#]+)/

			name = m[1]

			unless name.match self._nameRx

				throw Error "tag name `#{name}` is not valid"

			parts.name = name

			k = k.substr name.length, k.length

		# tag id
		if m = k.match /^#([a-zA-Z0-9\-]+)/

			id = m[1]

			unless id.match self._nameRx

				throw Error "tag id `#{id}` is not valid"

			attribs.id = id

			k = k.substr id.length + 1, k.length

		classes = []

		# the class attrib
		while m = k.match /\.([a-zA-Z0-9\-\_]+)/

			cls = m[1]

			unless cls.match self._nameRx

				throw Error "tag class `#{cls}` is not valid"

			classes.push cls

			k = k.replace '.' + cls, ''

		if classes.length

			attribs.class = classes.join " "

		# TODO: match attributes like [a=b]

		parts

	constructor: (node) ->

		if typeof node is 'string'

			parts = self._parseTag node

			if parts.name.length is 0

				parts.name = 'div'

			node = document.createElement parts.name

			for name, val of parts.attribs

				node.setAttribute name, val

		unless node instanceof Element

			throw Error "node must be an HTML element."

		@node = node

		if not @_shouldCloneInnerHTML?

			@_shouldCloneInnerHTML = no

		self.__initMixinsFor @

		@_parent = null

		@_children = []





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

		timing.afterFrame =>

			# if not newself._beenAppended

			# 	newself.putIn parent

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

	putIn: (el) ->

		if @_parent?

			@_parent._notYourChildAnymore @

		if el instanceof self

			el._append @
			@_parent = el

		else

			el.appendChild @node
			@_parent = null

		@

	takeOutOfParent: ->

		if @_parent?

			@_parent._notYourChildAnymore @

		@_parent = null

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