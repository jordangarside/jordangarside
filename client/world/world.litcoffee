
	Router.route '/', ->
		@redirect("world")

	Router.map ->
		@route "world",
			path: "/world/:eventID?"
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

	Router.map ->
		@route "colors",
			path: "/colors/:eventID?"
			controller: "colorsController"
			template: "world"

	class @colorsController extends worldController
		onBeforeAction: ->
			window.jordan.useColors = true
			$('body').addClass('colors')
		onAfterAction: ->
			window.jordan.backgroundColorChanger()