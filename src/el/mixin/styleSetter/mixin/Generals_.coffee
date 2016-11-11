css = require '../../../../utility/css'

module.exports = class General_

	z: (i) ->

		@node.style.zIndex = i

		@

	css: (prop, val) ->

		@_styles[prop] = val

		@

	addClass: (c) ->

		@node.classList.add c

		@

	removeClass: (c) ->

		@node.classList.remove c

		@

	toggleClass: (c) ->

		@node.classList.toggle c

		@

	setClass: (c) ->

		@node.className = c

		@