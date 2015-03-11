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
	translationDelta		= 0

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
		rotationAmount						= new Famous.Transitionable 0
		delta_rotationAmount				= 0
		mainContext							= FView.byId("mainCtx").context
		mainContextNode						= FView.byId("mainCtx").node
		contentContainer					= FView.byId('rootContainer').view
		#starsContainerTranslationModifier	= FView.byId('starContainerTranslationModifir').modifier
		animationsContainer					= FView.byId("animationsAlignmentModifier").node

		#testSurface = new Famous.Surface
		#	size: [300, 200]
		#	properties:
		#		backgroundColor: "red"
		#contentContainer.add(testSurface)

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
			translationDelta = delta
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

		#WebGL Stuff
		canvasWidth		= largerScreenDimension
		canvasHeight	= 300

		canvasMaskModifier = new Famous.Modifier
			origin:		[ 0.5, 0 ]
			align:		[ 0.5, 1 ]
			transform:	Famous.Transform.translate(0, -200, 0)
		canvasMask		= new Famous.ContainerSurface
			size:		[ 2000, 2000 ]
			properties:
				backgroundColor:	"black"
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
			content: "<canvas id='worldCanvas'></canvas>"
			size: [ canvasWidth, canvasHeight ]
		
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

			for i in [0..parameters.length-1]
				color					= parameters[i][0]
				size					= parameters[i][1]

				materials[i] = new THREE.PointCloudMaterial
					size: size

				particles = new THREE.PointCloud( geometry, materials[i] )

				particles.rotation.x	= Math.random() * 6
				particles.rotation.y	= Math.random() * 6
				particles.rotation.z	= Math.random() * 6

				scene.add( particles )

			renderer = new THREE.WebGLRenderer
				canvas: threeCanvas
				devicePixelRatio: window.devicePixelRatio
			renderer.setSize( canvasWidth, canvasHeight )

			console.log camera
			cameraInitialY = camera.position.y
			cameraInitialZ = camera.position.z
			render = ->
				time = Date.now() * 0.00005

				for i in [0..scene.children.length-1]
					object = scene.children[ i ]
					if object instanceof THREE.PointCloud
						object.rotation.y = time * ( i < 4 ? i + 1 : - (i + 1))
						#Appear to rotate world by rotating stars
						object.rotation.x = -rotationAmount.get()

				for i in [0..materials.length-1]
					color = parameters[i][0]
					h = ( 360 * ( color[0] + time ) % 360 ) / 360
					materials[i].color.setHSL( h, color[1], color[2] )

				renderer.render( scene, camera )
			Famous.Engine.on('prerender', render )
		), 250

		Famous.Engine.on('postrender', ->
			delta_rotationAmount = 0
		)

		#Chrome Mobile Warning
		userAgent = navigator.userAgent
		if (/Chrome\/[.0-9]* Mobile/ig.test(userAgent))
			#alert("Chrome Mobile is currently broken, try Firefox.")
			userAgent