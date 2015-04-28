window.Famous ?= {}
window.jordan ?= {}

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

#Offsets (unexpanded)
dateYOffset			= -(jordan.worldHeightShowing + jordan.marginOne +
	jordan.descriptionSize[1] + jordan.marginTwo +
	jordan.imageSize[1] + jordan.marginThree +
	jordan.headerSize[1] + jordan.marginFour)

headerYOffset		= -(jordan.worldHeightShowing + jordan.marginOne +
	jordan.descriptionSize[1] + jordan.marginTwo +
	jordan.imageSize[1] + jordan.marginThree)

imageYOffset		= -(jordan.worldHeightShowing + jordan.marginOne +
	jordan.descriptionSize[1] + jordan.marginTwo)

descriptionYOffset	= -(jordan.worldHeightShowing + jordan.marginOne)

#Offsets (expanded)
expandedDateOffsets		= []
expandedDateOffsets[0]	= jordan.backMargins[3]
expandedDateOffsets[1]	= jordan.backMargins[0] + jordan.backSize[1] + jordan.headerSize[1] - 20

expandedHeaderOffsets		= []
expandedHeaderOffsets[0] 	= jordan.backMargins[3] + 20 + jordan.dateSize[1] + 5
expandedHeaderOffsets[1] 	= jordan.backMargins[0] + jordan.backSize[1] + 10

expandedImageOffsets	= []
expandedImageOffsets[0]	= -20
expandedImageOffsets[1]	= -20

expandedDescriptionOffsets		= []
expandedDescriptionOffsets[0]	= jordan.backMargins[3] + 20
expandedDescriptionOffsets[1]	= jordan.backMargins[0] + jordan.backSize[1] + 10 + jordan.headerSize[1] + 5

# Import Famous
require 'famous/core/famous'
# Adds the famo.us dependencies
require 'famous-polyfills'

# Load Famo.us libraries
Famous.Engine					= require 'famous/core/Engine'
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
			month: 10
			year: 1993
		title: "born."
		text: "the day it all started"
		#imageURL: "/images/animations/panda.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			year: 1994
		title: "walked"
		text: "the journey begins"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/error.gif" # "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif" # "/images/image2.jpg"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/error.gif" # "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif" # "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 1994
		title: "walked"
		text: "the journey begins"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/error.gif" # "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif" # "/images/image2.jpg"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/error.gif" # "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif" # "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 1994
		title: "walked"
		text: "the journey begins"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/error.gif" # "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif" # "/images/image2.jpg"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/error.gif" # "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif" # "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 1994
		title: "walked"
		text: "the journey begins"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		#imageURL: "/images/animations/error.gif" # "/images/animations/demo.gif"
		imageURL: "/images/animations/error.gif" # "/images/image2.jpg"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		#imageURL: "/images/animations/error.gif" # "/images/animations/landscape.gif"
		imageURL: "/images/animations/error.gif" # "/images/animations/error.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "/images/animations/error.gif" # "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "/images/animations/error.gif" # "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
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

			lifeEventContainerSurface = new Famous.ContainerSurface
				size: [undefined, undefined]

			dateModifier	= new Famous.Modifier
				origin: [0, 1]
				align: [0.5, 1]
			dateSurface				= new Famous.Surface
				size: jordan.dateSize
				classes: ["date-container"]
				content: "
					<h4 style='display: inline-block; vertical-align: baseline; margin: 0;'>#{jordan.lifeEvents[index].date.year}</h4>
				"

			headerModifier	= new Famous.Modifier
				origin: [0.5, 1]
				align: [0.5, 1]
				size: jordan.headerSize
			headerSurface				= new Famous.Surface
				classes: ["header-container"]
				content: "<h1 style='display: inline-block; margin: 0;'>#{jordan.lifeEvents[index].title}</h1>"

			imageModifier	= new Famous.Modifier
				origin: [0.5, 1]
				align: [0.5, 1]
			imageSurface 				= new Famous.Surface
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
			descriptionSurface				= new Famous.Surface
				size: jordan.descriptionSize
				classes: ['description-container']
				content: "
					<p style='width:#{jordan.descriptionSize[0]}px; text-align: center;'>#{jordan.lifeEvents[index].text}</p>
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
					{@topThetaValue, @currentThetaTransitionable} = options
					@topThetaValue = index * Math.PI / 2
					if not @topThetaValue?
						throw "topThetaValue must be specified"
					if not @currentThetaTransitionable?
						throw "currentThetaTransitionable must be specified"

					dateModifier.transformFrom =>
						return Famous.Transform.translate(0, dateYOffset, 0)
					headerModifier.transformFrom =>
						return Famous.Transform.translate(0, headerYOffset, 0) 
					imageModifier.transformFrom =>
						return Famous.Transform.translate(0, imageYOffset, 0)
					descriptionModifier.transformFrom =>
						return Famous.Transform.translate(0, descriptionYOffset, 0)

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
				.add(lifeEventRenderController)

			jordan.lifeEvents[index].expand = (callback) ->
				jordan.showBackButton()
				jordan.lifeEvents[index].expanded = true
				jordan.disableDragEvents()
				doExpand = =>
					#Date
					dateTranslationTransitionable	= new Famous.Transitionable [0, dateYOffset, 0]
					dateOriginTransitionable 		= new Famous.Transitionable [0.5, 1]

					dateModifier.transformFrom ->
						dateTranslation = dateTranslationTransitionable.get()
						return Famous.Transform.translate(dateTranslation[0], dateTranslation[1], dateTranslation[2])
					dateModifier.originFrom ->
						return dateOriginTransitionable.get()
					dateModifier.alignFrom ->
						return dateOriginTransitionable.get()

					dateTranslationTransitionable.set([expandedDateOffsets[0], expandedDateOffsets[1], 0], {curve: "inOutCubic", duration: 700})
					dateOriginTransitionable.set([0, 0], {curve: "inOutCubic", duration: 700})
					
					#Header
					headerTranslationTransitionable = new Famous.Transitionable [0, headerYOffset, 0]
					headerOriginTransitionable 		= new Famous.Transitionable [0.5, 1]

					headerModifier.transformFrom ->
						headerTranslation = headerTranslationTransitionable.get()
						return Famous.Transform.translate(headerTranslation[0], headerTranslation[1], headerTranslation[2])
					headerModifier.originFrom ->
						return headerOriginTransitionable.get()
					headerModifier.alignFrom ->
						return headerOriginTransitionable.get()

					headerTranslationTransitionable.set([expandedHeaderOffsets[0], expandedHeaderOffsets[1], 0], {curve: "inOutCubic", duration: 700})
					headerOriginTransitionable.set([0, 0], {curve: "inOutCubic", duration: 700})

					#Image
					imageTranslationTransitionable 	= new Famous.Transitionable [0, imageYOffset, 0]
					imageOriginTransitionable 		= new Famous.Transitionable [0.5, 1]

					imageModifier.transformFrom ->
						imageTranslation = imageTranslationTransitionable.get()
						return Famous.Transform.translate(imageTranslation[0], imageTranslation[1], 0)
					imageModifier.originFrom ->
						return imageOriginTransitionable.get()
					imageModifier.alignFrom ->
						return imageOriginTransitionable.get()

					imageTranslationTransitionable.set([expandedImageOffsets[0], expandedImageOffsets[1], 0], {curve: "inOutCubic", duration: 700})
					imageOriginTransitionable.set([1, 1], {curve: "inOutCubic", duration: 700})

					#Description
					descriptionTranslationTransitionable 	= new Famous.Transitionable [0, descriptionYOffset, 0]
					descriptionOriginTransitionable 		= new Famous.Transitionable [0.5, 1]

					descriptionModifier.transformFrom ->
						descriptionTranslation = descriptionTranslationTransitionable.get()
						return Famous.Transform.translate(descriptionTranslation[0], descriptionTranslation[1], 0)
					descriptionModifier.originFrom ->
						return descriptionOriginTransitionable.get()
					descriptionModifier.alignFrom ->
						return descriptionOriginTransitionable.get()

					descriptionTranslationTransitionable.set([expandedDescriptionOffsets[0], expandedDescriptionOffsets[1], 0], {curve: "inOutCubic", duration: 700})
					descriptionOriginTransitionable.set([0, 0], {curve: "inOutCubic", duration: 700})

					#Move stars down
					jordan.starsTranslation.set([0, 200, 0], {curve: "inOutCubic", duration: 700})

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
				#Date
				dateTranslationTransitionable	= new Famous.Transitionable([expandedDateOffsets[0], expandedDateOffsets[1], 0])
				dateOriginTransitionable		= new Famous.Transitionable [0, 0]
	
				dateModifier.transformFrom ->
					dateTranslation = dateTranslationTransitionable.get()
					return Famous.Transform.translate(dateTranslation[0], dateTranslation[1], dateTranslation[2])
				dateModifier.originFrom ->
					return dateOriginTransitionable.get()
				dateModifier.alignFrom ->
					return dateOriginTransitionable.get()

				dateTranslationTransitionable.set([0, dateYOffset, 0], {curve: "inOutCubic", duration: 700})
				dateOriginTransitionable.set([0.5, 1], {curve: "inOutCubic", duration: 700})

				#Header
				headerTranslationTransitionable	= new Famous.Transitionable([expandedHeaderOffsets[0], expandedHeaderOffsets[1], 0])
				headerOriginTransitionable		= new Famous.Transitionable [0, 0]

				headerModifier.transformFrom ->
					headerTranslation = headerTranslationTransitionable.get()
					return Famous.Transform.translate(headerTranslation[0], headerTranslation[1], headerTranslation[2])
				headerModifier.originFrom ->
					return headerOriginTransitionable.get()
				headerModifier.alignFrom ->
					return headerOriginTransitionable.get()
				headerModifier.sizeFrom ->
					return [jordan.headerSize[0], jordan.headerSize[1]]

				headerTranslationTransitionable.set([0, headerYOffset, 0], {curve: "inOutCubic", duration: 700})
				headerOriginTransitionable.set([0.5, 1], {curve: "inOutCubic", duration: 700})

				#Image
				imageTranslationTransitionable	= new Famous.Transitionable([expandedImageOffsets[0], expandedImageOffsets[1], 0])
				imageOriginTransitionable		= new Famous.Transitionable [1, 1]

				imageModifier.transformFrom ->
					imageTranslation = imageTranslationTransitionable.get()
					return Famous.Transform.translate(imageTranslation[0], imageTranslation[1], imageTranslation[2])
				imageModifier.originFrom ->
					return imageOriginTransitionable.get()
				imageModifier.alignFrom ->
					return imageOriginTransitionable.get()

				imageTranslationTransitionable.set([0, imageYOffset, 0], {curve: "inOutCubic", duration: 700})
				imageOriginTransitionable.set([0.5, 1], {curve: "inOutCubic", duration: 700})

				#Description
				descriptionTranslationTransitionable	= new Famous.Transitionable([expandedDescriptionOffsets[0], expandedDescriptionOffsets[1], 0])
				descriptionOriginTransitionable			= new Famous.Transitionable [0, 0]

				descriptionModifier.transformFrom ->
					descriptionTranslation = descriptionTranslationTransitionable.get()
					return Famous.Transform.translate(descriptionTranslation[0], descriptionTranslation[1], descriptionTranslation[2])
				descriptionModifier.originFrom ->
					return descriptionOriginTransitionable.get()
				descriptionModifier.alignFrom ->
					return descriptionOriginTransitionable.get()

				descriptionTranslationTransitionable.set([0, descriptionYOffset, 0], {curve: "inOutCubic", duration: 700})
				descriptionOriginTransitionable.set([0.5, 1], {curve: "inOutCubic", duration: 700})

				jordan.starsTranslation.set [0, -200, 0], {curve: "inOutCubic", duration: 700}, ->
					jordan.lifeEvents[index].expanded = false
					jordan.enableDragEvents()
					jordan.hideBackButton()

			#Events
			imageSurface.on "click", _.throttle ((event) ->
				Router.go("world", {eventID: index})
			), 1000

jordan.closeEvent = (callback) ->
	jordan.hideBackButton()
	lifeEvent 	= _.findWhere(jordan.lifeEvents, {expanded: true})
	if lifeEvent?
		lifeEvent.close(callback)
	else
		callback()