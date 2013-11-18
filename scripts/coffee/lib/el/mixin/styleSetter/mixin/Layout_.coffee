module.exports = class Layout_

	__initMixinLayout: ->

		@_layout =

			width: null

			height: null

			clipLeft: 'auto'

			clipRight: 'auto'

			clipTop: 'auto'

			clipBottom: 'auto'

	setWidth: (w) ->

		@_layout.width = w

		@_styles.width = w + 'px'

		@

	setHeight: (h) ->

		@_layout.height = h

		@_styles.height = h + 'px'

		@

	clip: (top, right, bottom, left) ->

		@_layout.clipTop = top
		@_layout.clipRight = right
		@_layout.clipBottom = bottom
		@_layout.clipLeft = left

		if typeof top is 'number' then top += 'px'
		if typeof right is 'number' then right += 'px'
		if typeof bottom is 'number' then bottom += 'px'
		if typeof left is 'number' then left += 'px'

		@_styles.clip = "rect(#{top}, #{right}, #{bottom}, #{left})"

		@

	unclip: ->

		@clip 'auto', 'auto', 'auto', 'auto'

		@

	clipTop: (a) ->

		@clip a, @_layout.clipRight, @_layout.clipBottom, @_layout.clipLeft

	clipRight: (a) ->

		@clip @_layout.clipTop, a, @_layout.clipBottom, @_layout.clipLeft

	clipBottom: (a) ->

		@clip @_layout.clipTop, @_layout.clipRight, a, @_layout.clipLeft

	clipLeft: (a) ->

		@clip @_layout.clipTop, @_layout.clipRight, @_layout.clipBottom, a