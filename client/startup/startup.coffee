window.Famous ?= {}
window.jordan ?= {}

# Import Famous
require 'famous/core/famous'
# Adds the famo.us dependencies
require 'famous-polyfills'

# Load Famo.us libraries
Famous.Engine					= require 'famous/core/Engine'
Famous.Surface					= require 'famous/core/Surface'
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
Famous.TransitionableTranform	= require 'famous/transitions/TransitionableTransform'
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

jordan.lifeEvents = [
		date:
			month: 10
			year: 1993
		title: "born."
		text: "the day it all started"
		imageURL: "/images/animations/panda.gif"
		#imageURL: "/images/image1.jpg"
	,
		date:
			month: 12
			year: 2014
		title: "car"
		text: "started living in my car"
		imageURL: "/images/animations/fire.gif"
		#imageURL: "/images/image2.jpg"
	,
		date:
			month: 1
			year: 2014
		title: "college"
		text: "got a chemistry degree from CSULB"
		imageURL: "/images/animations/landscape.gif"
		#imageURL: "/images/image3.jpg"
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

jordan.prepareLifeEvents = (options) ->
	{@container} = options
	_.each jordan.lifeEvents, (lifeEvent, index) =>
		if not jordan.lifeEvents[index].created?
			jordan.lifeEvents[index].created	= true
			jordan.lifeEvents[index].enabled	= false
			lifeEventRenderController			= new Famous.RenderController()
			lifeEventSize						= jordan.lifeEvents[index].size ? [150, 100]
			lifeEventSurface					= new Famous.Surface
				size: [true,true]
				content: "
					<div>
						<h1 style='display: inline-block; margin: 0;'>#{jordan.lifeEvents[index].title}</h1>
						<h4 style='display: inline-block; vertical-align: baseline; margin: 0;'>#{jordan.lifeEvents[index].date.year}</h4>
					</div>
					<img src='#{jordan.lifeEvents[index].imageURL}' width='#{lifeEventSize[0]}px' height='#{lifeEventSize[1]}px' style=''>
					<p style='width:#{lifeEventSize[0]}px; text-align: center;'>#{jordan.lifeEvents[index].text}</p>
				"
				properties:
					backfaceVisibility: "visible"
			rotationXModifier	= new Famous.Modifier()
			rotationYModifier	= new Famous.Modifier()
			translationModifier	= new Famous.Modifier
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
					oldThetaValue = undefined
					rotationXModifier.transformFrom =>
						thetaTransitionable = @currentThetaTransitionable.get()
						if oldThetaValue isnt thetaTransitionable
							thetaOffset = @topThetaValue - thetaTransitionable
							return Famous.Transform.rotateX(thetaOffset)
					rotationYModifier.transformFrom =>
						twoPi			= 6.283185 # 2 * Math.PI
						piOverFour		= 0.7853982 # Math.PI / 4
						sevenPiOverFour	= 5.497787 # 7 * Math.PI / 4

						thetaTransitionable = @currentThetaTransitionable.get()
						thetaOffset = Math.abs((@topThetaValue - thetaTransitionable)) - (twoPi * (Math.floor(thetaTransitionable / (twoPi))))
						#console.log "Index: #{index}, thetaOffset: #{thetaOffset}"
						switch
							when -(piOverFour) < thetaOffset <= 0
								return Famous.Transform.rotateY(thetaOffset)
							when (sevenPiOverFour) < thetaOffset <= twoPi
								return Famous.Transform.rotateY(-(twoPi - thetaOffset))
							when 0 < thetaOffset < piOverFour
								return Famous.Transform.rotateY(-thetaOffset)
							else
								return Famous.Transform.rotateY(-piOverFour)
					lifeEventRenderController.show(lifeEventSurface, {curve: "linear", duration: 0})
			jordan.lifeEvents[index].disable = ->
				if jordan.lifeEvents[index].enabled
					jordan.lifeEvents[index].enabled = false
					#Stop Transforms and Hide Surface
					rotationXModifier.transformFrom()
					rotationYModifier.transformFrom()
					lifeEventRenderController.hide()
			@container
				.add(rotationYModifier)
				.add(rotationXModifier)
				.add(translationModifier)
				.add(lifeEventRenderController)