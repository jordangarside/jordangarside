
	Router.map ->
		@route "world",
			path: "/"
			controller: "worldController"

	class @worldController extends RouteController
		onBeforeAction: () ->
			document.title = "jordan garside"
			return @next()
		waitOn: -> return
		action: ->
			if this.ready()
				this.render()
			else
				this.render('loading')
		onAfterAction: -> return
		onStop: -> return