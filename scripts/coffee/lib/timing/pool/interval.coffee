define ->

	intervalPool =

		_pool: []

		_getNew: (every, from, timesCalled, fn) ->

			{
				every: every
				from: from
				timesCalled: timesCalled
				fn: fn
			}

		give: (every, from, timesCalled, fn) ->

			if intervalPool._pool.length > 0

				item = intervalPool._pool.pop()

				item.every = every
				item.from = from
				item.timesCalled = timesCalled
				item.fn = fn

				return item

			else

				return intervalPool._getNew every, from, timesCalled, fn

		take: (item) ->

			intervalPool._pool.push item

			null