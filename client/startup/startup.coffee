window.Famous ?= {}
window.jordan ?= {}

# Import Famous
require 'famous/core/famous'
# Adds the famo.us dependencies
require 'famous-polyfills'

# Load Famo.us libraries
Famous.Engine	= require 'famous/core/Engine'

jordan.boxSize				= [500, 750]
jordan.boxSizeMax			= [500, 750]
jordan.boxMargins			= [0, 0, 0, 0]
jordan.titleMargins			= [30, 0, 0, 40]
jordan.titleSize			= [70, 40]
jordan.backMargins			= [30, 0, 0, 20]
jordan.backSize				= [40, 40]


jordan.dateSize				= [50, 20]
jordan.marginFour			= 0
jordan.headerSize			= [150, 50]
jordan.marginThree			= 15
jordan.imageSize			= [150, 100]
jordan.marginTwo			= 10
jordan.descriptionSize		= [150, 50]
jordan.marginOne			= 10
jordan.worldHeightShowing	= 200

expandTransition			= {curve: "inOutCubic", duration: 700}


Famous.Engine.on 'resize', =>
	#Offsets (unexpanded)
	jordan.dateYOffset			= -(jordan.worldHeightShowing + jordan.marginOne +
		jordan.descriptionSize[1] + jordan.marginTwo +
		jordan.imageSize[1] + jordan.marginThree +
		jordan.headerSize[1] + jordan.marginFour)

	jordan.headerYOffset		= -(jordan.worldHeightShowing + jordan.marginOne +
		jordan.descriptionSize[1] + jordan.marginTwo +
		jordan.imageSize[1] + jordan.marginThree)

	jordan.imageYOffset		= -(jordan.worldHeightShowing + jordan.marginOne +
		jordan.descriptionSize[1] + jordan.marginTwo)

	jordan.descriptionYOffset	= -(jordan.worldHeightShowing + jordan.marginOne)

	#Offsets (expanded)
	jordan.expandedDateOffsets		= []
	jordan.expandedDateOffsets[0]	= jordan.backMargins[3]
	jordan.expandedDateOffsets[1]	= jordan.backMargins[0] + jordan.backSize[1] + jordan.headerSize[1] - 20

	jordan.expandedHeaderOffsets		= []
	jordan.expandedHeaderOffsets[0] 	= jordan.backMargins[3] + jordan.dateSize[0] + 15
	jordan.expandedHeaderOffsets[1] 	= jordan.backMargins[0] + jordan.backSize[1] + 10

	jordan.expandedImageOffsets	= []
	jordan.expandedImageOffsets[0]	= -20
	jordan.expandedImageOffsets[1]	= -20

	jordan.expandedDescriptionOffsets		= []
	jordan.expandedDescriptionOffsets[0]	= jordan.backMargins[3] + 20
	jordan.expandedDescriptionOffsets[1]	= jordan.backMargins[0] + jordan.backSize[1] + 10 + jordan.headerSize[1] + 5


Famous.Surface					= require 'famous/core/Surface'
Famous.CanvasSurface			= require 'famous/surfaces/CanvasSurface'
Famous.ContainerSurface			= require 'famous/surfaces/ContainerSurface'
Famous.Transform				= require 'famous/core/Transform'
Famous.View						= require 'famous/core/View'
Famous.Modifier					= require 'famous/core/Modifier'
Famous.RenderNode				= require 'famous/core/RenderNode'
Famous.StateModifier			= require 'famous/modifiers/StateModifier'
Famous.HeaderFooter				= require 'famous/views/HeaderFooterLayout'
Famous.RenderController			= require 'famous/views/RenderController'
Famous.ViewSequence				= require 'famous/core/ViewSequence'
Famous.SequentialLayout			= require 'famous/views/SequentialLayout'
Famous.ImageSurface				= require 'famous/surfaces/ImageSurface'
Famous.FastClick				= require 'famous/inputs/FastClick'
Famous.GenericSync				= require 'famous/inputs/GenericSync'
Famous.MouseSync				= require 'famous/inputs/MouseSync'
Famous.TouchSync				= require 'famous/inputs/TouchSync'
Famous.GenericSync.register
	'mouse': Famous.MouseSync
	'touch': Famous.TouchSync
Famous.Easing					= require 'famous/transitions/Easing'
Famous.Transitionable			= require 'famous/transitions/Transitionable'
Famous.TransitionableTransform	= require 'famous/transitions/TransitionableTransform'
Famous.TweenTransition			= require 'famous/transitions/TweenTransition'
SpringTransition				= require('famous/transitions/SpringTransition')
WallTransition					= require('famous/transitions/WallTransition')
SnapTransition					= require('famous/transitions/SnapTransition')

Famous.Utilities				= require 'famous/utilities/Utility'
Famous.Timer					= require 'famous/utilities/Timer'

#Register Tween Transitions
Famous.TweenTransition.registerCurve('inOutCubic', Famous.Easing.inOutCubic)

#Register Physics Methods
Famous.Transitionable.registerMethod('spring', SpringTransition)
Famous.Transitionable.registerMethod('wall', WallTransition)
Famous.Transitionable.registerMethod('snap', SnapTransition)

Famous.cursorToArray = (cursor, data, createFn, elementsBefore) ->
	elementsBefore ?= 0
	cursor.observe
		addedAt: (document, atIndex, before) ->
			console.log "Element added atIndex: #{atIndex} with _id: #{document._id}"
			data.splice(atIndex+elementsBefore, 0, createFn(document))
		changedAt: (newDocument, oldDocument, atIndex) ->
			console.log "Element changed atIndex: #{atIndex} with _id: #{newDocument._id}"
			data[atIndex+elementsBefore] = createFn(newDocument)
		removedAt: (oldDocument, atIndex) ->
			console.log "Element removed atIndex: #{atIndex}"
			data.splice(atIndex+elementsBefore, 1)
		movedTo: (document, fromIndex, toIndex, before) ->
			console.log "Element movedFrom #{fromIndex} to #{toIndex}"
			@removedAt(undefined, fromIndex)
			@addedAt(document, toIndex)


jordan.rotationTransitionable 	= new Famous.Transitionable 0
jordan.starsTranslation			= new Famous.Transitionable([0, -200, 0])

jordan.lifeEvents = [
		date:
			age: 0
		title: "born."
		text: "was born on October 8th, 1993 at Cedar Sinai hospital."
		#imageURL: "/images/animations/panda.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			age: 12
		title: "atech"
		text: "started attending Advanced Technologies University (high school). I was a computer science major there for 2 years, but left grade 11 to graduate early."
		imageURL: "/images/animations/school.gif"
	,
		date:
			age: 15
		title: "mira costa"
		text: "transferred to Mira Costa High School for grade 12 to graduate early and to get in-state California tuition."
		imageURL: "/images/animations/school.gif"
	,
		date:
			age: 16
		title: "uc merced"
		text: "started college at UC Merced as a biology major. I left for Long Beach State after deciding it was a better option for me."
		imageURL: "/images/animations/school.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			age: 17
		title: "csulb"
		text: "transferred to Long Beach State and became a chemistry major."
		imageURL: "/images/animations/school.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			age: 18
		title: "research"
		text: "started doing research in electrochemistry, more specifically electron tunneling junctions on mercury and EGaIn."
		imageURL: "/images/animations/junction.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			age: 19
		title: "inlet"
		text: "began working on <a target='_blank' href='https://www.inlet.nu'>inlet</a> (desktop) because I felt it was an important idea that needed to be done."
		imageURL: "/images/animations/inlet.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			age: 21
		title: "paper"
		text: "published a <a target='_blank' href='http://www.electrochemsci.org/papers/vol9/90804345.pdf'>research paper</a> with Dr. Slowinski et al."
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			age: 21
		title: "graduation"
		text: "graduated from Long Beach State with my degree in chemistry."
		imageURL: "/images/animations/graduation.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			age: 21
		title: "inletM"
		text: "started working on a mobile application for <a target='_blank' href='http://www.inlet.nu/cordova'>inlet</a> based in polymer and famo.us."
		imageURL: "/images/animations/inletMobile.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			age: 21
		title: "this page"
		text: "began working on jordangarside.com as a way to demonstrate some of my web design capabilities, although it doesn't show validation, batch work, or database management."
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
]

jordan.months = [
	"January"
	"February"
	"March"
	"April"
	"May"
	"June"
	"July"
	"August"
	"September"
	"October"
	"November"
	"December"
]

twoPi			= 6.2832 # 2 * Math.PI
piOverFour		= 0.7853982 # Math.PI / 4
piOverFive		= 0.62832 # Math.PI / 5
sevenPiOverFour	= 5.497787 # 7 * Math.PI / 4
ninePiOverFive	= 5.6549 # 9 * Math.PI / 5

jordan.prepareLifeEvents = (options) ->
	{@container} = options
	_.each jordan.lifeEvents, (lifeEvent, index) =>
		if not jordan.lifeEvents[index].created?
			jordan.lifeEvents[index].created	= true
			jordan.lifeEvents[index].enabled	= false
			lifeEventRenderController			= new Famous.RenderController
				inTrasition:
					curve: 'linear'
					duration: 0
				outTransition:
					curve: 'linear'
					duration: 0
				overlap: true
			pictureSize			= jordan.lifeEvents[index].size ? jordan.imageSize

			lifeEventContainerModifier	= new Famous.Modifier
				size: [undefined, undefined]
			lifeEventContainerSurface 	= new Famous.ContainerSurface
				classes: ["life-event-container"]
			lifeEventContainerModifier.sizeFrom ->
				return jordan.boxSize

			dateModifier	= new Famous.Modifier
				origin: [0, 1]
				align: [0.5, 1]
			dateSurface		= new Famous.Surface
				size: jordan.dateSize
				classes: ["date-container"]
				content: "
					<h4 style='display: inline-block; vertical-align: baseline; margin: 0;'>age #{jordan.lifeEvents[index].date.age}</h4>
				"

			headerModifier	= new Famous.Modifier
				origin: [0.5, 1]
				align: [0.5, 1]
				size: jordan.headerSize
			headerSurface	= new Famous.Surface
				classes: ["header-container"]
				content: "<h1 class='header'>#{jordan.lifeEvents[index].title}</h1>"

			imageModifier	= new Famous.Modifier
				origin: [0.5, 1]
				align: [0.5, 1]
			imageSurface 	= new Famous.Surface
				size: jordan.imageSize
				classes: ["image-container"]
				content: "
					<img src='#{jordan.lifeEvents[index].imageURL}' width='#{pictureSize[0]}px' height='#{pictureSize[1]}px' style=''>
				"
				properties:
					backfaceVisibility: "visible"
					textAlign:			"center"

			descriptionModifier	= new Famous.Modifier
				origin: [0.5, 1]
				align: [0.5, 1]
				size: jordan.descriptionSize
			descriptionSurface	= new Famous.Surface
				classes: ['description-container']
				content: "
					<p class='description'>#{jordan.lifeEvents[index].text}</p>
				"

			rotationXModifier	= new Famous.Modifier()
			rotationYModifier	= new Famous.Modifier()
	
			lifeEventContainer = lifeEventContainerSurface
			lifeEventContainer.add(dateModifier).add(dateSurface)
			lifeEventContainer.add(headerModifier).add(headerSurface)
			lifeEventContainer.add(imageModifier).add(imageSurface)
			lifeEventContainer.add(descriptionModifier).add(descriptionSurface)

			#Enable LifeEvent
			jordan.lifeEvents[index].enable = (options) ->
				if not jordan.lifeEvents[index].enabled
					jordan.lifeEvents[index].enabled = true
					#Start Transform and Show Surface
					@topThetaValue				= index * Math.PI / 2
					@currentThetaTransitionable	= jordan.rotationTransitionable

					dateModifier.transformFrom =>
						return Famous.Transform.translate(0, jordan.dateYOffset, 0)
					headerModifier.transformFrom =>
						return Famous.Transform.translate(0, jordan.headerYOffset, 0) 
					imageModifier.transformFrom =>
						return Famous.Transform.translate(0, jordan.imageYOffset, 0)
					descriptionModifier.transformFrom =>
						return Famous.Transform.translate(0, jordan.descriptionYOffset, 0)

					rotationXModifier.transformFrom =>
						thetaOffset = @topThetaValue - @currentThetaTransitionable.get()
						return Famous.Transform.rotateZ(thetaOffset)
					rotationYModifier.transformFrom =>
						thetaTransitionable = @currentThetaTransitionable.get()
						thetaOffset = Math.abs((@topThetaValue - thetaTransitionable)) - (twoPi * (Math.floor(thetaTransitionable / (twoPi))))
						#console.log "Index: #{index}, thetaOffset: #{thetaOffset}"
						switch
							when -(piOverFive) < thetaOffset <= 0
								return Famous.Transform.rotateY(-thetaOffset)
							when (ninePiOverFive) < thetaOffset <= twoPi
								return Famous.Transform.rotateY((twoPi - thetaOffset))
							when 0 < thetaOffset < piOverFive
								return Famous.Transform.rotateY(thetaOffset)
							else
								return Famous.Transform.rotateY(piOverFive)
					lifeEventRenderController.show(lifeEventContainerSurface, {curve: "linear", duration: 0})

			#Disable LifeEvent
			jordan.lifeEvents[index].disable = ->
				if jordan.lifeEvents[index].enabled
					console.log "lifeEvent #{index}: Hiding..."
					jordan.lifeEvents[index].enabled = false
					#Stop Transforms and Hide Surface
					headerModifier.transformFrom
					imageModifier.transformFrom()
					rotationXModifier.transformFrom()
					rotationYModifier.transformFrom()
					lifeEventRenderController.hide()
			@container
				.add(rotationYModifier)
				.add(rotationXModifier)
				.add(lifeEventContainerModifier)
				.add(lifeEventRenderController)

			jordan.lifeEvents[index].expand = (callback) ->
				jordan.showBackButton()
				jordan.lifeEvents[index].expanded = true
				jordan.disableDragEvents()
				doExpand = =>
					jordan.lifeEvents[index - 1]?.disable()
					jordan.lifeEvents[index + 1]?.disable()

					lifeEventContainerSurface.addClass('expanded')

					#Date
					dateTranslationTransitionable	= new Famous.Transitionable [0, jordan.dateYOffset, 0]
					dateOriginTransitionable 		= new Famous.Transitionable [0.5, 1]

					dateModifier.transformFrom ->
						dateTranslation = dateTranslationTransitionable.get()
						return Famous.Transform.translate(dateTranslation[0], dateTranslation[1], dateTranslation[2])
					dateModifier.originFrom ->
						return dateOriginTransitionable.get()
					dateModifier.alignFrom ->
						return dateOriginTransitionable.get()

					dateTranslationTransitionable.set([jordan.expandedDateOffsets[0], jordan.expandedDateOffsets[1], 0], expandTransition)
					dateOriginTransitionable.set([0, 0], expandTransition)
					
					#Header
					headerTranslationTransitionable = new Famous.Transitionable [0, jordan.headerYOffset, 0]
					headerOriginTransitionable 		= new Famous.Transitionable [0.5, 1]
					headerSizeTransitionable		= new Famous.Transitionable jordan.headerSize

					headerModifier.transformFrom ->
						headerTranslation = headerTranslationTransitionable.get()
						return Famous.Transform.translate(headerTranslation[0], headerTranslation[1], headerTranslation[2])
					headerModifier.originFrom ->
						return headerOriginTransitionable.get()
					headerModifier.alignFrom ->
						return headerOriginTransitionable.get()
					headerModifier.sizeFrom ->
						return headerSizeTransitionable.get()

					headerTranslationTransitionable.set([jordan.expandedHeaderOffsets[0], jordan.expandedHeaderOffsets[1], 0], expandTransition)
					headerOriginTransitionable.set([0, 0], expandTransition)
					headerSizeTransitionable.set([(jordan.boxSize[0] - jordan.expandedHeaderOffsets[0] - 20), jordan.headerSize[1]], expandTransition)

					#Image
					imageTranslationTransitionable 	= new Famous.Transitionable [0, jordan.imageYOffset, 0]
					imageOriginTransitionable 		= new Famous.Transitionable [0.5, 1]

					imageModifier.transformFrom ->
						imageTranslation = imageTranslationTransitionable.get()
						return Famous.Transform.translate(imageTranslation[0], imageTranslation[1], 0)
					imageModifier.originFrom ->
						return imageOriginTransitionable.get()
					imageModifier.alignFrom ->
						return imageOriginTransitionable.get()

					imageTranslationTransitionable.set([jordan.expandedImageOffsets[0], jordan.expandedImageOffsets[1], 0], expandTransition)
					imageOriginTransitionable.set([1, 1], expandTransition)

					#Description
					descriptionTranslationTransitionable 	= new Famous.Transitionable [0, jordan.descriptionYOffset, 0]
					descriptionOriginTransitionable 		= new Famous.Transitionable [0.5, 1]
					descriptionSizeTransitionable			= new Famous.Transitionable jordan.descriptionSize

					descriptionModifier.transformFrom	->
						descriptionTranslation	= descriptionTranslationTransitionable.get()
						return Famous.Transform.translate(descriptionTranslation[0], descriptionTranslation[1], 0)
					descriptionModifier.originFrom		->
						return descriptionOriginTransitionable.get()
					descriptionModifier.alignFrom		->
						return descriptionOriginTransitionable.get()
					descriptionModifier.sizeFrom		->
						return descriptionSizeTransitionable.get()

					descriptionTranslationTransitionable.set([jordan.expandedDescriptionOffsets[0], jordan.expandedDescriptionOffsets[1], 0], expandTransition)
					descriptionOriginTransitionable.set([0, 0], expandTransition)
					expandedDescriptionSize	= jordan.boxSize[0] - 2*jordan.expandedDescriptionOffsets[0]
					if jordan.worldHeightShowing == 50
						expandedDescriptionSize = expandedDescriptionSize / 2
					descriptionSizeTransitionable.set([expandedDescriptionSize, jordan.descriptionSize[1]], expandTransition)

					#Move stars down
					jordan.starsTranslation.set([0, jordan.worldHeightShowing, 0], expandTransition)

					if callback?
						callback()
				if Math.abs(jordan.rotationTransitionable.get() - (index * Math.PI / 2)) > Math.PI / 4
					jordan.rotationTransitionable.halt()
					jordan.rotationTransitionable.set(index * Math.PI / 2,
						curve: 'inOutCubic'
						duration: 1200
					, ->
						doExpand()
					)
				else
					doExpand()

			jordan.lifeEvents[index].close = (callback) ->
				lifeEventContainerSurface.removeClass('expanded')

				#Date
				dateTranslationTransitionable	= new Famous.Transitionable([jordan.expandedDateOffsets[0], jordan.expandedDateOffsets[1], 0])
				dateOriginTransitionable		= new Famous.Transitionable [0, 0]
	
				dateModifier.transformFrom ->
					dateTranslation = dateTranslationTransitionable.get()
					return Famous.Transform.translate(dateTranslation[0], dateTranslation[1], dateTranslation[2])
				dateModifier.originFrom ->
					return dateOriginTransitionable.get()
				dateModifier.alignFrom ->
					return dateOriginTransitionable.get()

				dateTranslationTransitionable.set([0, jordan.dateYOffset, 0], expandTransition)
				dateOriginTransitionable.set([0.5, 1], expandTransition)

				#Header
				headerTranslationTransitionable	= new Famous.Transitionable [jordan.expandedHeaderOffsets[0], jordan.expandedHeaderOffsets[1], 0]
				headerOriginTransitionable		= new Famous.Transitionable [0, 0]
				headerSizeTransitionable		= new Famous.Transitionable [(jordan.boxSize[0] - jordan.expandedHeaderOffsets[0] - 20), jordan.headerSize[1]]

				headerModifier.transformFrom ->
					headerTranslation = headerTranslationTransitionable.get()
					return Famous.Transform.translate(headerTranslation[0], headerTranslation[1], headerTranslation[2])
				headerModifier.originFrom	->
					return headerOriginTransitionable.get()
				headerModifier.alignFrom	->
					return headerOriginTransitionable.get()
				headerModifier.sizeFrom		->
					return headerSizeTransitionable.get()

				headerTranslationTransitionable.set([0, jordan.headerYOffset, 0], expandTransition)
				headerOriginTransitionable.set([0.5, 1], expandTransition)
				headerSizeTransitionable.set(jordan.headerSize, expandTransition)

				#Image
				imageTranslationTransitionable    = new Famous.Transitionable([jordan.expandedImageOffsets[0], jordan.expandedImageOffsets[1], 0])
				imageOriginTransitionable		= new Famous.Transitionable [1, 1]

				imageModifier.transformFrom ->
					imageTranslation = imageTranslationTransitionable.get()
					return Famous.Transform.translate(imageTranslation[0], imageTranslation[1], imageTranslation[2])
				imageModifier.originFrom ->
					return imageOriginTransitionable.get()
				imageModifier.alignFrom ->
					return imageOriginTransitionable.get()

				imageTranslationTransitionable.set([0, jordan.imageYOffset, 0], expandTransition)
				imageOriginTransitionable.set([0.5, 1], expandTransition)

				#Description
				descriptionTranslationTransitionable	= new Famous.Transitionable([jordan.expandedDescriptionOffsets[0], jordan.expandedDescriptionOffsets[1], 0])
				descriptionOriginTransitionable			= new Famous.Transitionable [0, 0]
				descriptionSizeTransitionable			= new Famous.Transitionable [(jordan.boxSize[0] - 2*jordan.expandedDescriptionOffsets[0]), jordan.descriptionSize[1]]

				descriptionModifier.transformFrom ->
					descriptionTranslation = descriptionTranslationTransitionable.get()
					return Famous.Transform.translate(descriptionTranslation[0], descriptionTranslation[1], descriptionTranslation[2])
				descriptionModifier.originFrom ->
					return descriptionOriginTransitionable.get()
				descriptionModifier.alignFrom ->
					return descriptionOriginTransitionable.get()
				descriptionModifier.sizeFrom ->
					return descriptionSizeTransitionable.get()

				descriptionTranslationTransitionable.set([0, jordan.descriptionYOffset, 0], expandTransition)
				descriptionOriginTransitionable.set([0.5, 1], expandTransition)
				descriptionSizeTransitionable.set(jordan.descriptionSize, expandTransition)

				jordan.starsTranslation.set [0, -jordan.worldHeightShowing, 0], expandTransition, ->
					jordan.lifeEvents[index - 1]?.enable()
					jordan.lifeEvents[index + 1]?.enable()
					jordan.lifeEvents[index].expanded = false
					jordan.enableDragEvents()
					jordan.hideBackButton()

			#Events
			imageSurface.on "click", _.throttle ((event) ->
				if jordan.lifeEvents[index].expanded
					Router.go("world")
				else
					Router.go("world", {eventID: index})
			), 1000

jordan.closeEvent = (callback) ->
	jordan.hideBackButton()
	if jordan.eventExpanded()
		lifeEvent 	= _.findWhere(jordan.lifeEvents, {expanded: true})
		lifeEvent.close(callback)
	else
		callback()

jordan.eventExpanded = ->
	lifeEvent 	= _.findWhere(jordan.lifeEvents, {expanded: true})
	if lifeEvent?
		return true
	else
		return false