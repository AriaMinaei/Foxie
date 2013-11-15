getCSSProp = do ->

	p = null

	el = document.createElement 'div'

	(possibleProps) ->

		for prop in possibleProps

			return prop if el.style[prop] isnt undefined

		false

cssPropertySetter = (prop) ->

	actualProp = getCSSProp getPossiblePropsFor prop

	return (->) unless actualProp

	(el, v) -> el.style[actualProp] = v

getPossiblePropsFor = (prop) ->

	[
		'webkit' + prop[0].toUpperCase() + prop.substr(1, prop.length),

		'moz' + prop[0].toUpperCase() + prop.substr(1, prop.length),

		prop
	]

module.exports = css =

	setTransform: cssPropertySetter 'transform'

	setTransformStyle: cssPropertySetter 'transformStyle'

	setTransformOrigin: cssPropertySetter 'transformOrigin'

	setCssFilter: cssPropertySetter 'filter'

	setTransitionDuration: cssPropertySetter 'transitionDuration'

	setTransitionTimingFunction: cssPropertySetter 'transitionTimingFunction'

	# Turns numbers to css rgb representation
	rgb: (r, g, b) ->

		'rgb(' + r + ', ' + g + ', ' + b + ')'