module.exports = timeoutPool =

	_pool: []

	_getNew: (time, fn) ->

		{
			time: time
			fn: fn
		}

	give: (time, fn) ->

		if @_pool.length > 0

			item = @_pool.pop()

			item.time = time

			item.fn = fn

			return item

		else

			return @_getNew time, fn

	take: (item) ->

		@_pool.push item

		null