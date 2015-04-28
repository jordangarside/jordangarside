
	Router.map ->
		@route "world",
			path: "/:eventID?"
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
		onAfterAction: ->
			params = @getParams()
			Session.set("eventID", params.eventID)
		onStop: -> return