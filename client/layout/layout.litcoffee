	updateStopTransition =
		method: 'snap'
		dampingRatio: 1
		period: 500
	worldWidth = 2000

	createSurfaces = (parentContainer) ->
		console.log parentContainer
		_.each jordan.lifeEvents, (lifeEvent, index) ->
			lifeEventSurface = new Famous.Surface
				size: [50,50]
				class: "demo-person"
				properties:
					backgroundColor: 'red'
			lifeEventModifier = new Famous.Modifier
				transform: Famous.Transform.rotateX(Math.PI)
			parentContainer.add(lifeEventModifier).add(lifeEventSurface)

	Template.layout.rendered = ->
		translationAmount = new Famous.Transitionable 0
		rotationAmount = new Famous.Transitionable 0
		mainContext = FView.byId("mainCtx").context
		mainContextNode = FView.byId("mainCtx").node
		contentContainer = FView.byId('rootContainer').view
		starsContent = FView.byId('starsContainer').view
		starsPositionModifer = new Famous.Modifier()
		starsContainer = starsContent.add(starsPositionModifer)
		starsPositionModifer = FView.byId('starsPositionModifier').modifier
		starsSurface = FView.byId('starsSurface').surface

		generateStars = (options) ->
			{@container, @higherPositionLimit, @lowerPositionLimit} = options
			container = @container
			higherPositionLimit = @higherPositionLimit
			lowerPositionLimit = @lowerPositionLimit
			maxStars = (lowerPositionLimit - higherPositionLimit) * 2
			numberOfStars = _.random(0, maxStars)
			stars = ""
			for i in [0..numberOfStars]
				alignmentXPosition = Math.round(Math.random() * worldWidth)
				YOffsetPosition = _.random(higherPositionLimit, lowerPositionLimit)
				size = _.random(1, 4)
				testModifier = new Famous.Modifier
					origin: [alignmentXPosition, 0]
					align: [alignmentXPosition, 0]
					transform: Famous.Transform.translate(0,YOffsetPosition,50)
				
				testSurface = new Famous.Surface
					size: [size,size]
					properties:
						backgroundColor: 'white'
				stars += "
					<div class='star'
					style='
						height:#{size}px;
						left: #{alignmentXPosition}px;
						top: #{YOffsetPosition}px;
						width:#{size}px;
					'>
					</div>
				"
			starsContent.add(testModifier).add(testSurface)
			starsSurface.setContent(stars)
		generateStars
			container: starsSurface
			higherPositionLimit: -1000
			lowerPositionLimit: 1000
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
			translationAmount.halt()
			rotationAmount.halt()
			current_translationAmount = translationAmount.get()
			current_rotationAmount = rotationAmount.get()
			#If slip is true then it's scroll and needs a ratio
			if event.slip == true
				delta = event.delta / 24
			else
				delta = event.delta
			new_translationAmount = current_translationAmount + delta
			delta_rotationAmount = delta * Math.PI / 360
			new_rotationAmount = current_rotationAmount + delta_rotationAmount
			if event.slip == true
				translationAmount.set(new_translationAmount, {duration: 30, curve: "linear"})
				rotationAmount.set(new_rotationAmount, {duration: 30, curve: "linear"})
			else
				translationAmount.set(new_translationAmount)
				rotationAmount.set(new_rotationAmount)
		contentSync.on "end", (event) ->
			console.log "event - contentContainer: end"
			translationAmount.halt()
			rotationAmount.halt()
			current_translationAmount = translationAmount.get()
			current_rotationAmount = rotationAmount.get()
			delta_translationAmount = event.velocity * 180
			delta_rotationAmount = event.velocity * Math.PI / 2
			new_translationAmount = current_translationAmount + delta_translationAmount
			new_rotationAmount = current_rotationAmount + delta_rotationAmount
			translationAmount.set(new_translationAmount, updateStopTransition)
			rotationAmount.set(new_rotationAmount, updateStopTransition)
		personRotationXModifier.transformFrom ->
			return Famous.Transform.rotateX(rotationAmount.get())
		personRotationZModifier.transformFrom ->
			return Famous.Transform.rotateZ(rotationAmount.get())
		starsPositionModifer.transformFrom ->
			return Famous.Transform.translate(0,translationAmount.get(),0)

		#Lagometer
		Lagometer = require("famous-lagometer/Lagometer")
		lagometerModifier = new Famous.Modifier(
			size: [
				100
				100
			]
			align: [
				1.0
				0.0
			]
			origin: [
				1.0
				0.0
			]
			transform: Famous.Transform.translate(-10, 20, 100)
		)
		lagometer = new Lagometer(size: lagometerModifier.getSize()) # required'
		mainContextNode.add(lagometerModifier).add(lagometer)