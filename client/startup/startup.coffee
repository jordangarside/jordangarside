window.Famous ?= {}
window.jordan ?= {}

# Import Famous
require 'famous/core/famous'
# Adds the famo.us dependencies
require 'famous-polyfills'

# Load Famo.us libraries
Famous.Engine           = require 'famous/core/Engine'
Famous.Surface          = require 'famous/core/Surface'
Famous.ContainerSurface = require 'famous/surfaces/ContainerSurface'
Famous.Transform        = require 'famous/core/Transform'
Famous.View             = require 'famous/core/View'
Famous.Modifier         = require 'famous/core/Modifier'
Famous.RenderNode		= require 'famous/core/RenderNode'
Famous.StateModifier    = require 'famous/modifiers/StateModifier'
Famous.HeaderFooter     = require 'famous/views/HeaderFooterLayout'
Famous.RenderController = require 'famous/views/RenderController'
Famous.ViewSequence		= require 'famous/core/ViewSequence'
Famous.SequentialLayout = require 'famous/views/SequentialLayout'
Famous.ImageSurface     = require 'famous/surfaces/ImageSurface'
Famous.FastClick        = require 'famous/inputs/FastClick'
Famous.GenericSync      = require 'famous/inputs/GenericSync'
Famous.MouseSync        = require 'famous/inputs/MouseSync'
Famous.TouchSync        = require 'famous/inputs/TouchSync'
Famous.GenericSync.register
	'mouse': Famous.MouseSync
	'touch': Famous.TouchSync
Famous.Easing           = require 'famous/transitions/Easing'
Famous.Transitionable   = require 'famous/transitions/Transitionable'
Famous.TransitionableTranform = require 'famous/transitions/TransitionableTransform'
Famous.TweenTransition  = require 'famous/transitions/TweenTransition'
SpringTransition = require('famous/transitions/SpringTransition')
WallTransition = require('famous/transitions/WallTransition')
SnapTransition = require('famous/transitions/SnapTransition')

Famous.Utilities		= require 'famous/utilities/Utility'
Famous.Timer            = require 'famous/utilities/Timer'

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

jordan.lifeEvents = [
		date:
			month: 10
			year: 1993
		title: "born."
		text: "this is some text"
		imageURL: "/images/animations/panda.gif"
	,
		date:
			month: 12
			year: 1993
		title: "born."
		text: "this is some text"
		imageURL: "/images/animations/fire.gif"
	,
		date:
			month: 1
			year: 1994
		title: "donut."
		text: "not text"
		imageURL: "/images/animations/landscape.gif"
	,
		date:
			month: 8
			year: 2009
		title: "UC Merced"
		text: "started attending."
		imageURL: "http://i.imgur.com/UDFoIEy.gif"
	,
		date:
			year: 2010
		title: "going to long beach"
		text: "this is some text"
		imageURL: "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
	,
		date:
			year: 2014
		title: "graduating from long beach"
		text: "this is some text"
		imageURL: "http://www.scribblelive.com/wp-content/uploads/2014/01/panda.gif"
]

jordan.prepareLifeEvents = (options) ->
	{@container} = options
	_.each jordan.lifeEvents, (lifeEvent, index) =>
		if not jordan.lifeEvents[index].created?
			jordan.lifeEvents[index].created = true
			jordan.lifeEvents[index].enabled = false
			lifeEventRenderController = new Famous.RenderController()
			lifeEventSize = jordan.lifeEvents[index].size ? [200, 150]
			lifeEventSurface = new Famous.ImageSurface
				size: lifeEventSize
				content: jordan.lifeEvents[index].imageURL
			rotationXModifier = new Famous.Modifier()
			rotationZModifier = new Famous.Modifier()
			translationModifier = new Famous.Modifier
				transform: Famous.Transform.translate(0, -210, 0)
			jordan.lifeEvents[index].enable = (options) ->
				if not jordan.lifeEvents[index].enabled
					jordan.lifeEvents[index].enabled = true
					#Start Transform and Show Surface
					{@topThetaValue, @currentThetaTransitionable} = options
					if not @topThetaValue?
						throw "topThetaValue must be specified"
					if not @currentThetaTransitionable?
						throw "currentThetaTransitionable must be specified"
					rotationXModifier.transformFrom =>
						thetaOffset = @currentThetaTransitionable.get() - @topThetaValue
						return Famous.Transform.rotateX(thetaOffset)
					rotationZModifier.transformFrom =>
						thetaOffset = @currentThetaTransitionable.get() - @topThetaValue
						return Famous.Transform.rotateZ(thetaOffset)
					lifeEventRenderController.show(lifeEventSurface)
			jordan.lifeEvents[index].disable = ->
				if jordan.lifeEvents[index].enabled
					jordan.lifeEvents[index].enabled = false
					#Stop Transforms and Hide Surface
					rotationXModifier.transformFrom()
					rotationZModifier.transformFrom()
					lifeEventRenderController.hide()
			@container
				.add(rotationXModifier)
				.add(rotationZModifier)
				.add(translationModifier)
				.add(lifeEventRenderController)