	updateStopTransition =
		method: 'snap'
		dampingRatio: 1
		period: 500
	worldWidth				= 2000
	visibleHeight			= 200
	visibleWidth			= 1200
	starSectionArray		= []
	starSectionArrayOffset	= 1
	starSectionHeight		= 100
	if window.screen.width > window.screen.height
		starSectionWidth = window.screen.width
	else
		starSectionWidth = window.screen.height
	if starSectionWidth > visibleWidth
		maxStars = (starSectionHeight * 4) / 3
	else
		maxStars = ((starSectionHeight * 4) / 3) * (starSectionWidth/visibleWidth)

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
		translationAmount					= new Famous.Transitionable 0
		rotationAmount						= new Famous.Transitionable 0
		mainContext							= FView.byId("mainCtx").context
		mainContextNode						= FView.byId("mainCtx").node
		contentContainer					= FView.byId('rootContainer').view
		starsContent						= FView.byId('starsContainer').view
		starsContainer						= starsContent.add(starsPositionModifer)
		starsContainerTranslationModifier	= FView.byId('starContainerTranslationModifir').modifier
		starsPositionModifer				= FView.byId('starsPositionModifier').modifier
		starsPositionModifierNode			= FView.byId('starsPositionModifier').node
		animationsContainer					= FView.byId("animationsAlignmentModifier").node
		#starSectionsRenderController = new Famous.RenderController()
		#starsPositionModifierNode.add(starSectionsRenderController)
		jordan.prepareLifeEvents({container: animationsContainer})
		jordan.lifeEvents[0].enable
			topThetaValue: 0
			currentThetaTransitionable: rotationAmount
		jordan.lifeEvents[1].enable
			topThetaValue: Math.PI / 2
			currentThetaTransitionable: rotationAmount
		jordan.lifeEvents[3].enable
			topThetaValue: Math.PI
			currentThetaTransitionable: rotationAmount

		starsContainerTranslationModifier.transformFrom ->
			starsTranslation = jordan.starsTranslation.get()
			return Famous.Transform.translate(starsTranslation[0], starsTranslation[1], starsTranslation[2])

		onOrientationChange = ->
			size = mainContext.getSize()
			switch
				when size[0] > size[1] and size[1] < 500
					#landscape small device
					jordan.starsTranslation.set([0,-75,0], {curve: "inOutCubic", duration: 300})
				else
					jordan.starsTranslation.set([0,-200,0], {curve: "inOutCubic", duration: 300})
		onOrientationChange()
		Famous.Engine.on 'resize', onOrientationChange
			
		showStarSection = (options) ->
			{@section} = options
			if not starSectionArray[starSectionArrayOffset + @section]?
				console.log "Creating Star Section: #{@section}"
				offset = @section * starSectionHeight
				starSectionArray[starSectionArrayOffset + @section] = generateStars
					container: starsPositionModifierNode
					offset: offset
					surfaceSize: starSectionHeight
				window.starSectionArray = starSectionArray

		generateStars = (options) ->
			{@container, @offset} = options
			container	= @container
			offset		= @offset
			stars		= generateStarsContent()
			# --------------- Z-Index Fixer -----------
			testModifier = new Famous.Modifier
				origin: [0, 0]
				align: [0, 0]
				transform: Famous.Transform.translate(0,0,50)
			testSurface = new Famous.Surface
				size: [10,10]
				properties:
					backgroundColor: 'white'
			starsContent.add(testModifier).add(testSurface)
			# -----------------------------------------
			starSectionModifier = new Famous.Modifier
				origin: [.5, 0]
				align: [.5, 0]
				transform: Famous.Transform.translate(0,offset,0)
			starSection = new Famous.Surface
				content: stars
				size: [starSectionWidth, starSectionHeight]
			container.add(starSectionModifier).add(starSection)
			return {
				surface: starSection
				modifier: starSectionModifier
				offset: offset
			}
		generateStarsContent = ->
			numberOfStars = _.random(0, maxStars)
			stars = ""
			for i in [0..numberOfStars]
				alignmentXPosition	= _.random(0, starSectionWidth)
				YOffsetPosition		= _.random(0, starSectionHeight)
				starSize			= _.random(1, 4)
				stars += "
					<div class='star'
					style='
						height:#{starSize}px;
						left: #{alignmentXPosition}px;
						top: #{YOffsetPosition}px;
						width:#{starSize}px;
					'>
					</div>
				"
			return stars
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
			if not event.slip? or event.slip == false
				delta = event.delta
			else
				delta = event.delta / 24
				
			new_translationAmount	= current_translationAmount + delta
			delta_rotationAmount	= (-1) * delta * 0.0087 #Math.PI / 360
			new_rotationAmount		= current_rotationAmount + delta_rotationAmount
			if not event.slip? or event.slip == false
				translationAmount.set(new_translationAmount)
				if new_rotationAmount > 0
					rotationAmount.set(new_rotationAmount)
				else
					rotationAmount.set(0)
			else
				translationAmount.set(new_translationAmount, {duration: 30, curve: "linear"})
				if new_rotationAmount > 0
					rotationAmount.set(new_rotationAmount, {duration: 30, curve: "linear"})
				else
					rotationAmount.set(0, {duration: 30, curve: "linear"})
				
		contentSync.on "end", (event) ->
			console.log "event - contentContainer: end"
			translationAmount.halt()
			rotationAmount.halt()
			current_translationAmount	= translationAmount.get()
			current_rotationAmount		= rotationAmount.get()
			delta_translationAmount		= event.velocity * 180
			delta_rotationAmount		= (-1) * event.velocity * Math.PI / 2
			new_translationAmount		= current_translationAmount + delta_translationAmount
			new_rotationAmount			= current_rotationAmount + delta_rotationAmount
			translationAmount.set(new_translationAmount, updateStopTransition)
			if new_rotationAmount > 0
				rotationAmount.set(new_rotationAmount, updateStopTransition)
			else
				rotationAmount.set(0, updateStopTransition)

		previousStarSection = 0
		numberOfVisibleSections = Math.floor(visibleHeight/starSectionHeight)
		for i in [previousStarSection-1..previousStarSection+numberOfVisibleSections+1]
			showStarSection({section: i})
		starsReady = false
		starsPositionModifer.transformFrom ->
			currentStarSection = -Math.round(translationAmount.get() / starSectionHeight)
			if currentStarSection isnt previousStarSection
				sortedStarSectionArray = _.sortBy starSectionArray, 'offset'
				if currentStarSection > previousStarSection
					newOffset = sortedStarSectionArray[sortedStarSectionArray.length - 1].offset + starSectionHeight
					starSectionArrayIndex = starSectionArray.indexOf(sortedStarSectionArray[0])
					starSectionArray[starSectionArrayIndex].offset = newOffset
					starSectionArray[starSectionArrayIndex].surface.setContent(generateStarsContent())
					starSectionArray[starSectionArrayIndex].modifier.setTransform(Famous.Transform.translate(0,newOffset,0))
				else
					newOffset = sortedStarSectionArray[0].offset - starSectionHeight
					starSectionArrayIndex = starSectionArray.indexOf(sortedStarSectionArray[sortedStarSectionArray.length - 1])
					starSectionArray[starSectionArrayIndex].offset = newOffset
					starSectionArray[starSectionArrayIndex].surface.setContent(generateStarsContent())
					starSectionArray[starSectionArrayIndex].modifier.setTransform(Famous.Transform.translate(0,newOffset,0))
			previousStarSection = currentStarSection
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
