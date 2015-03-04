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
		date: "1993"
		title: "born."
	,
		date: "1993"
		title: "born."
	,
		date: "2010"
		title: "going to long beach"
	,
		date: "2014"
		title: "graduating from long beach"
]