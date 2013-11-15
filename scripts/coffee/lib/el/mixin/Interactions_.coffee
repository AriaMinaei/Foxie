module.exports = class Interactions_

	onClick: ->

		@_eventEnabledMethod arguments, (cb) =>

			@node.addEventListener 'click', (e) =>

				e.preventDefault()

				cb.call @, e

	onTap: ->

		@_eventEnabledMethod arguments, (cb) =>

			@node.addEventListener 'touchstart', (e) =>

				e.preventDefault()

				cb.call @, e

			@node.addEventListener 'click', (e) =>

				e.preventDefault()

				cb.call @, e

	onMouseOver: ->

		@_eventEnabledMethod arguments, (cb) =>

			@node.addEventListener 'mouseover', (e) =>

				e.preventDefault()

				cb.call @, e

	onMouseOut: ->

		@_eventEnabledMethod arguments, (cb) =>

			@node.addEventListener 'mouseout', (e) =>

				e.preventDefault()

				cb.call @, e