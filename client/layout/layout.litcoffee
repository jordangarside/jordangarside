	window.jordan ?= {}

	updateStopTransition =
		method: 'snap'
		dampingRatio: 1
		period: 500
	updateSnapTransition =
		curve: 'inOutCubic'
		duration: 1200

	worldWidth				= 2000
	visibleHeight			= 200
	visibleWidth			= 1200
	starSectionArray		= []
	starSectionArrayOffset	= 1
	starSectionHeight		= 100
	eventSeparation			= Math.PI / 2

	if window.screen.width > window.screen.height
		largerScreenDimension	= window.screen.width
		smallerScreenDimension	= window.screen.height
	else
		largerScreenDimension	= window.screen.height
		smallerScreenDimension	= window.screen.width

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
		rotationAmount						= jordan.rotationTransitionable
		mainContext							= FView.byId("mainCtx").context
		mainContextNode						= FView.byId("mainCtx").node
		contentContainer					= FView.byId('rootContainer').view
		#starsContainerTranslationModifier	= FView.byId('starContainerTranslationModifir').modifier
		mainContainer					= FView.byId("containerModifier").node

		titleModifier	= new Famous.StateModifier
			origin: [0, 0]
			align: [0, 0]
			transform: Famous.Transform.translate(jordan.titleMargins[3], jordan.titleMargins[0], 0)
		titleSurface	= new Famous.Surface
			size: jordan.titleSize
			classes: ["page-header"]
			content: "jordan"

		backRenderController	= new Famous.RenderController()
		backModifier	= new Famous.StateModifier
			origin: [0, 0]
			align: [0, 0]
			transform: Famous.Transform.translate(jordan.backMargins[3], jordan.backMargins[0], 1000)
		backSurface		= new Famous.Surface
			size: jordan.backSize
			classes: ["back-button-container"]
			content: "<span class='back-button fa fa-arrow-circle-o-left'></span>"

		backSurface.on "click", (event) ->
			console.log "CLICKED!"
			Router.go("world")

		mainContainer.add(titleModifier).add(titleSurface)
		mainContainer.add(backModifier).add(backRenderController)
		jordan.showBackButton = ->
			xTranslate	= jordan.backSize[0] + jordan.backMargins[3] + 10
			titleModifier.setTransform(Famous.Transform.translate(xTranslate, jordan.titleMargins[0], 0), {curve: "inOutCubic", duration: 400}, ->
				backRenderController.show(backSurface, {duration: 250})
			)
		jordan.hideBackButton = ->
			backRenderController.hide({duration: 200})
			titleModifier.setTransform(Famous.Transform.translate(jordan.titleMargins[3], jordan.titleMargins[0], 0), {curve: "inOutCubic", duration: 400})
		

		#testSurface = new Famous.Surface
		#	size: [300, 200]
		#	properties:
		#		backgroundColor: "red"
		#contentContainer.add(testSurface)

		jordan.prepareLifeEvents
			container: mainContainer

		lastEventRotationValue = (jordan.lifeEvents.length - 1) * (Math.PI / 2)

		#Render Events on the Fly
		lastRotationValue 	= -1
		lastClosestEvent	= -1
		Famous.Engine.on 'prerender', ->
			newRotationValue	= rotationAmount.get()
			if newRotationValue isnt lastRotationValue
				lastRotationValue 	= newRotationValue
				#Find Closest Event
				smallestCloseEvent 		= Math.floor(newRotationValue / eventSeparation)
				smallestCloseEventTheta	= smallestCloseEvent * eventSeparation
				largestCloseEvent 		= smallestCloseEvent + 1
				largestCloseEventTheta	= smallestCloseEventTheta + eventSeparation
				if Math.abs(newRotationValue - smallestCloseEventTheta) > Math.abs(newRotationValue - largestCloseEventTheta)
					closestEvent = largestCloseEvent
				else
					closestEvent = smallestCloseEvent
				if lastClosestEvent isnt closestEvent
					lastClosestEvent = closestEvent
					for lifeEvent, index in jordan.lifeEvents
						if index >= closestEvent - 1 and index <= closestEvent + 1
							jordan.lifeEvents[index]?.enable
								currentThetaTransitionable: rotationAmount
						else
							jordan.lifeEvents[index]?.disable()

		onOrientationChange = ->
			size			= mainContext.getSize()
			if size[0] < jordan.boxSizeMax[0]
				jordan.boxSize[0]	= size[0]
			else
				jordan.boxSize[0]	= jordan.boxSizeMax[0]
			if size[1] < jordan.boxSizeMax[1]
				jordan.boxSize[1]	= size[1]
			else
				jordan.boxSize[1]	= jordan.boxSizeMax[1]
			#Make world smaller for landscape phones
			switch
				when size[0] > size[1] and size[1] < 500
					jordan.worldHeightShowing	= 50
				else
					jordan.worldHeightShowing	= 200
			#Move world if there's not an event open
			if not jordan.eventExpanded()
				jordan.starsTranslation.set [0, -jordan.worldHeightShowing, 0], {curve: "inOutCubic", duration: 300}
		onOrientationChange()
		Famous.Engine.on 'resize', onOrientationChange


		updateContentRotation = (delta) ->
			translationAmount.halt()
			rotationAmount.halt()
			current_translationAmount = translationAmount.get()
			current_rotationAmount = rotationAmount.get()

			new_translationAmount	= current_translationAmount + delta
			delta_rotationAmount	= (-1) * delta * 0.0087 #Math.PI / 360
			new_rotationAmount		= current_rotationAmount + delta_rotationAmount
			translationAmount.set(new_translationAmount, {duration: 30, curve: "linear"})
			switch
				when new_rotationAmount <= 0
					rotationAmount.set(0, {duration: 30, curve: "linear"})
				when new_rotationAmount >= lastEventRotationValue
					rotationAmount.set(lastEventRotationValue, updateStopTransition)
				else
					rotationAmount.set(new_rotationAmount, {duration: 30, curve: "linear"})

		endContentRotation = (velocity) ->
			translationAmount.halt()
			rotationAmount.halt()
			current_translationAmount	= translationAmount.get()
			current_rotationAmount		= rotationAmount.get()
			delta_translationAmount		= velocity * 180
			delta_rotationAmount		= (-1) * velocity * Math.PI / 2
			new_translationAmount		= current_translationAmount + delta_translationAmount
			new_rotationAmount			= current_rotationAmount + delta_rotationAmount
			translationAmount.set(new_translationAmount, updateStopTransition)
			switch
				when new_rotationAmount <= 0
					rotationAmount.set(0, updateStopTransition)
				when new_rotationAmount >= lastEventRotationValue
					rotationAmount.set(lastEventRotationValue, updateStopTransition)
				else
					closestSnap = findClosestSnap(new_rotationAmount)
					rotationAmount.set(new_rotationAmount, updateStopTransition, ->
						rotationAmount.set(closestSnap, updateSnapTransition)
					)

		contentSync = new Famous.GenericSync(
			['mouse', 'touch', 'scroll']
		, {direction: Famous.GenericSync.DIRECTION_Y}
		)
		horizontalContentSync = new Famous.GenericSync(
			['mouse', 'touch', 'scroll']
		, {direction: Famous.GenericSync.DIRECTION_X}
		)
		scrollDirection = ""
		horizontalContentSync.on "update", (event) ->
			if scrollDirection == "" and Math.abs(event.position) > 15
				scrollDirection = "horizontal"
			if scrollDirection == "horizontal"
				#If slip is true then it's scroll and needs a ratio
				if not event.slip? or event.slip == false
					delta = event.delta
				else
					delta = event.delta / 14
				updateContentRotation(delta)
		horizontalContentSync.on "end", (event) ->
			if scrollDirection == "horizontal"
				scrollDirection = ""
				endContentRotation(event.velocity)
		contentSync.on "update", (event) ->
			if scrollDirection == "" and Math.abs(event.position) > 15
				scrollDirection = "vertical"
			if scrollDirection == "vertical"
				#If slip is true then it's scroll and needs a ratio
				if not event.slip? or event.slip == false
					delta = event.delta
				else
					delta = event.delta / 14
				updateContentRotation(delta)
		contentSync.on "end", (event) ->
			console.log "event - contentContainer: end"
			if scrollDirection == "vertical"
				scrollDirection = ""
				endContentRotation(event.velocity)

		jordan.enableDragEvents = ->
			contentContainer.pipe contentSync
			contentContainer.pipe horizontalContentSync
		jordan.enableDragEvents()
		jordan.disableDragEvents = ->
			contentContainer.unpipe contentSync
			contentContainer.unpipe horizontalContentSync
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
		#mainContextNode.add(lagometerModifier).add(lagometer)

		#WebGL Stuff
		canvasWidth		= largerScreenDimension
		canvasHeight	= 300

		canvasMaskModifier = new Famous.Modifier
			origin:		[ 0.5, 0 ]
			align:		[ 0.5, 1 ]
			transform:	Famous.Transform.translate(0, -200, 0)
		canvasMask = new Famous.ContainerSurface
			size:		[ 2000, 2000 ]
			properties:
				#backgroundColor:	"black"
				borderRadius:		"2000px"
				overflow:			"hidden"
		#Code for moving canvas on orientation change
		canvasMaskModifier.transformFrom ->
			starsTranslation = jordan.starsTranslation.get()
			return Famous.Transform.translate(starsTranslation[0], starsTranslation[1], starsTranslation[2])
		
		canvasContainerModifier = new Famous.Modifier
			origin:	[ 0.5, 0 ]
			align:	[ 0.5, 0 ]
		canvasContainer = new Famous.Surface
			classes: ['worldCanvasContainer', 'no-background-transition']
			content: "<canvas id='worldCanvas' class='no-background-transition' style=''></canvas>"
			size: [ canvasWidth, canvasHeight ]
			properties:
				backgroundColor: jordan.complementaryColor
		
		contentContainer.add(canvasMaskModifier).add(canvasMask)
		canvasMask.add(canvasContainerModifier).add(canvasContainer)

		setTimeout (->
			threeCanvas			= document.getElementById('worldCanvas')
			
			VIEW_ANGLE			= 75
			ASPECT				= largerScreenDimension / 300
			NEAR				= 1
			FAR					= 3000
			camera				= new THREE.PerspectiveCamera( VIEW_ANGLE, ASPECT, NEAR, FAR )
			camera.position.z	= 250
			numberOfStars		= largerScreenDimension

			scene				= new THREE.Scene()
			scene.fog			= new THREE.FogExp2( 0x000000, 0.0007 )

			geometry			= new THREE.Geometry()

			for i in [0..numberOfStars]
				vertex		= new THREE.Vector3()
				vertex.x	= _.random(0, 500) - 250
				vertex.y	= _.random(0, 500) - 250
				vertex.z	= _.random(0, 500) - 250
				geometry.vertices.push( vertex )

			parameters = [
				[ [1, 1, 0.5], 5],
				[ [0.95, 1, 0.5], 4 ],
				[ [0.90, 1, 0.5], 3 ],
				[ [0.85, 1, 0.5], 2 ],
				[ [0.80, 1, 0.5], 1 ]
			]
			materials	= []
			particles	= {}
			i			= 0
			h			= 0
			color		= []
			size		= 1

			for parameter, index in parameters
				color					= parameter[0]
				size					= parameter[1]

				materials[index] = new THREE.PointCloudMaterial
					size: size

				particles = new THREE.PointCloud( geometry, materials[index] )

				particles.rotation.x	= Math.random() * 6
				particles.rotation.y	= Math.random() * 6
				particles.rotation.z	= Math.random() * 6

				scene.add( particles )

			renderer = new THREE.WebGLRenderer
				alpha: true
				canvas: threeCanvas
				devicePixelRatio: window.devicePixelRatio
			renderer.setSize( canvasWidth, canvasHeight )
			renderer.setClearColor( 0x000000, 0 )

			temp = true
			render = ->
				time = Date.now() * 0.00005
				if temp
					console.log scene.children
					temp = false
				for object, index in scene.children
					if object instanceof THREE.PointCloud
						object.rotation.y = time * if index < 4 then index + 1 else -(index + 1)
						#Appear to rotate world by rotating stars
						object.rotation.x = -rotationAmount.get()

				for material, index in materials
					if window.jordan.useColors? and window.jordan.useColors
						material.color.setHSL( 255, 255, 255 )
					else 
						color = parameters[index][0]
						h = ( 360 * ( color[0] + time ) % 360 ) / 360
						material.color.setHSL( h, color[1], color[2] )
					
				renderer.render( scene, camera )
			Famous.Engine.on('prerender', render )
		), 250

		#Chrome Mobile Warning
		userAgent = navigator.userAgent
		if (/Chrome\/[.0-9]* Mobile/ig.test(userAgent))
			console.log("Chrome Mobile is currently broken, try Firefox.")

		Deps.autorun ->
			eventID = Session.get('eventID')
			jordan.closeEvent ->
				jordan.lifeEvents[eventID]?.expand()


	findClosestSnap = (theta) ->
		snapValue		= eventSeparation
		smallestTick	= Math.floor(theta / snapValue)
		smallestSnap	= smallestTick * snapValue
		largestSnap		= smallestSnap + snapValue
		snapToValue		= 0
		if Math.abs(theta - smallestSnap) > Math.abs(theta - largestSnap)
			snapToValue = largestSnap
		else
			snapToValue = smallestSnap
		return snapToValue

	window.jordan.backgroundColorChanger = ->
		changeBackground = ->
			randomColor = ->
				colorArray = []
				h = _.random(1, 360)
				s = _.random(80, 90)
				l = _.random(50, 60)
				h2 = undefined
				if h < 180
					h2 = h + 180
				else
					h2 = h - 180
				colorArray[0] = 'hsl(' + h + ',' + s + '%,' + l + '%)'
				colorArray[1] = 'hsl(' + h2 + ',' + s + '%,' + l + '%)'
				return colorArray
			colors = randomColor()
			jordan.backgroundColor 		= colors[0]
			jordan.complementaryColor	= colors[1]
			$('.root-container').css
				backgroundColor: colors[0]
			$('.worldCanvasContainer').css
				backgroundColor: colors[1]
		changeBackground()
		setTimeout (->
			$('.root-container').removeClass('no-background-transition')
			$('.worldCanvasContainer').removeClass('no-background-transition')
			setTimeout (->
				changeBackground()
				setInterval (->
					changeBackground()
				), 20000
			), 500
		), 2000