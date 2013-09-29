define [

	'./el/mixin/Styles_'
	'./el/mixin/Chain_'
	'./el/mixin/Timing_'
	'./el/mixin/Interactions_'
	'./timing/timing'
	'./utility/object'
	'./utility/array'
	'./utility/classic'
	'./utility/lazyValues'

], (Styles_, Chain_, Timing_, Interactions_, timing, object, array, classic, lazyValues) ->

	classic.mix Styles_, Chain_, Timing_, Interactions_, class El

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

			El.__initMixinsFor @

			@_beenAppended = no

			@_parent = null

			@_children = []

			timing.nextTick =>

				if not @_beenAppended

					if not @node.parentElement? and @node.tagName isnt 'BODY'

						@putIn El._getDefaultContainer()

					else

						@_beenAppended = yes

		clone: (newEl = Object.create @constructor::) ->

			@_doUpdate()

			# Adding the node
			newNode = @node.cloneNode()
			newEl.node = newNode
			newEl._children = []

			# Cloning the children
			if @_shouldCloneInnerHTML

				newEl.node.innerHTML = @node.innerHTML

			else

				for child in @_children

					child.clone().putIn newEl

			# Deciding on the parent
			newEl._parent = null

			if @_parent?

				parent = @_parent

			else

				parent = @node._parent ? @node.parentElement ? null

			newEl._beenAppended = no

			timing.afterFrame =>

				if not newEl._beenAppended

					newEl.putIn parent

				return

			El.__applyClonersFor @, [newEl]

			for key, val of @

				continue if newEl[key] isnt undefined

				if @hasOwnProperty key

					newEl[key] = object.clone val, yes

			newEl

		_notYourChildAnymore: (el) ->

			unless el instanceof El

				throw Error "`el` must be an instance of `El`"

			array.pluckItem @_children, el

			@

		putIn: (el = El._getDefaultContainer()) ->

			if @_parent?

				@_parent._notYourChildAnymore @

			if el instanceof El

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

			El._defaultContainer = @

			@

		_append: (el) ->

			if el instanceof El

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


			El.__applyQuittersFor @

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