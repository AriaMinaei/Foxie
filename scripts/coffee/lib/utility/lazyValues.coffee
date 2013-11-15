module.exports = lazyValues = {}

lazyValues.getLazyValue = (val) ->

	if val._isLazy? and val._isLazy

		return do val

	else

		return val

lazyValues.getLazyValues = (ar) ->

	lazyValues.getLazyValue item for item in ar

lazyValues.returnLazily = (fn) ->

	->

		args = arguments

		ret = =>

			fn.apply @, args

		ret._isLazy = yes

		ret

lazyValues.acceptLazyArgs = (fn) ->

	->

		args = lazyValues.getLazyValues arguments

		fn.apply @, args

lazyValues.acceptAndReturnLazily = (fn) ->

	lazyValues.returnLazily lazyValues.acceptLazyArgs fn

lazyValues