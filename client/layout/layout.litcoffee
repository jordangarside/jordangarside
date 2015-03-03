
	Template.layout.rendered = ->
		rotationAmount = new Famous.Transitionable 0
		contentContainer = FView.byId('rootContainer').view
		personRotationXModifier = FView.byId('personRotationXModifier').modifier
		personRotationZModifier = FView.byId('personRotationZModifier').modifier
		contentSync = new Famous.GenericSync(
			['mouse', 'touch', 'scroll']
		, {direction: Famous.GenericSync.DIRECTION_Y}
		)
		contentContainer.pipe contentSync
		contentSync.on "start", (event) ->
			console.log "event - contentContainer: start"
		contentSync.on "update", (event) ->
			console.log "event - contentContainer: update"
			console.log event
			current_rotationAmount = rotationAmount.get()
			#If Velocity is 0 then it's scroll and needs a ratio
			if event.slip == true
				delta = event.delta / 24
			else
				delta = event.delta
			delta_rotationAmount = delta * Math.PI / 360
			new_rotationAmount = current_rotationAmount + delta_rotationAmount
			rotationAmount.set(new_rotationAmount)
		contentSync.on "end", (event) ->
			console.log "event - contentContainer: end"
			console.log event
		personRotationXModifier.transformFrom ->
			return Famous.Transform.rotateX(rotationAmount.get())
		personRotationZModifier.transformFrom ->
			return Famous.Transform.rotateZ(rotationAmount.get())