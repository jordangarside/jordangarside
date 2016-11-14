import * as famous from 'famous'
import { projects } from '../projects/index.coffee'

GenericSync	= famous.inputs.GenericSync
MouseSync	= famous.inputs.MouseSync
TouchSync	= famous.inputs.TouchSync
ScrollSync  = famous.inputs.ScrollSync
GenericSync.register
	'mouse': MouseSync
	'scroll': ScrollSync
	'touch': TouchSync

updateBetweenTransition =
	curve: 'linear'
	duration: 0
updateStopTransition =
	method: 'snap'
	dampingRatio: 1
	period: 500
updateSnapTransition =
	curve: 'inOutCubic'
	duration: 1200

eventSeparation	= Math.PI / 2
lastEventRotationValue = (projects.length - 1) * (Math.PI / 2)

horizontalGenericInputs = null
verticalGenericInputs   = null

export registerListeners = ({ rotationAmountTransitionable, translationAmountTransitionable }) ->

	horizontalGenericInputs = new GenericSync(
		['mouse', 'touch', 'scroll'], 
		{direction: GenericSync.DIRECTION_X}
	)
	verticalGenericInputs = new GenericSync(
		['mouse', 'touch', 'scroll'], 
		{direction: GenericSync.DIRECTION_Y}
	)

	famous.core.Engine.pipe horizontalGenericInputs
	famous.core.Engine.pipe verticalGenericInputs

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

	updateContentRotation = (delta) ->
		translationAmountTransitionable.halt()
		rotationAmountTransitionable.halt()
		current_translationAmount = translationAmountTransitionable.get()
		current_rotationAmount = rotationAmountTransitionable.get()

		new_translationAmount	= current_translationAmount + delta
		delta_rotationAmount	= (-1) * delta * 0.0087 #Math.PI / 360
		new_rotationAmount		= current_rotationAmount + delta_rotationAmount
		translationAmountTransitionable.set(new_translationAmount, updateBetweenTransition)
		switch
			when new_rotationAmount <= 0
				rotationAmountTransitionable.set(0, updateBetweenTransition)
			when new_rotationAmount >= lastEventRotationValue
				rotationAmountTransitionable.set(lastEventRotationValue, updateStopTransition)
			else
				rotationAmountTransitionable.set(new_rotationAmount, updateBetweenTransition)

	endContentRotation = (velocity) ->
		translationAmountTransitionable.halt()
		rotationAmountTransitionable.halt()
		current_translationAmount	= translationAmountTransitionable.get()
		current_rotationAmount		= rotationAmountTransitionable.get()
		delta_translationAmount		= velocity * 180
		delta_rotationAmount		= (-1) * velocity * Math.PI / 2
		new_translationAmount		= current_translationAmount + delta_translationAmount
		new_rotationAmount			= current_rotationAmount + delta_rotationAmount
		translationAmountTransitionable.set(new_translationAmount, updateStopTransition)
		switch
			when new_rotationAmount <= 0
				rotationAmountTransitionable.set(0, updateStopTransition)
			when new_rotationAmount >= lastEventRotationValue
				rotationAmountTransitionable.set(lastEventRotationValue, updateStopTransition)
			else
				closestSnap = findClosestSnap(new_rotationAmount)
				rotationAmountTransitionable.set(new_rotationAmount, updateStopTransition, ->
					rotationAmountTransitionable.set(closestSnap, updateSnapTransition)
				)

	scrollDirection = ""
	horizontalGenericInputs.on "update", (event) ->
		if scrollDirection == "" and Math.abs(event.position) > 15
			scrollDirection = "horizontal"
		if scrollDirection == "horizontal"
			#If slip is true then it's scroll and needs a ratio
			if not event.slip? or event.slip == false
				delta = event.delta
			else
				delta = event.delta / 14
			updateContentRotation(delta)
	horizontalGenericInputs.on "end", (event) ->
		if scrollDirection == "horizontal"
			scrollDirection = ""
			endContentRotation(event.velocity)

	verticalGenericInputs.on "update", (event) ->
		if scrollDirection == "" and Math.abs(event.position) > 15
			scrollDirection = "vertical"
		if scrollDirection == "vertical"
			console.log "event - verticalGenericInputs: update"
			#If slip is true then it's scroll and needs a ratio
			if not event.slip? or event.slip == false
				delta = event.delta
			else
				delta = event.delta / 14
			updateContentRotation(delta)
	verticalGenericInputs.on "end", (event) ->
		if scrollDirection == "vertical"
			console.log "event - verticalGenericInputs: end"
			scrollDirection = ""
			endContentRotation(event.velocity)

export cleanupListeners = ->
	console.log "Listeners: Cleaning up...."
	horizontalGenericInputs.removeListener "update"
	horizontalGenericInputs.removeListener "end"
	verticalGenericInputs.removeListener "update"
	verticalGenericInputs.removeListener "end"
	famous.core.Engine.unpipe horizontalGenericInputs
	famous.core.Engine.unpipe verticalGenericInputs
	horizontalGenericInputs = null
	verticalGenericInputs = null