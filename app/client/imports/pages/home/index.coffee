import * as famous from 'famous'

import homeTemplate from './index.handlebars'
import { renderStars, cleanupStars } from './stars/index.coffee'
import { registerListeners, cleanupListeners} from './listeners/index.coffee'
import { renderProjects, cleanupProjects } from './projects/index.coffee'

import isMobileDevice from '../../utils/is_mobile_device/index.coffee'

FamousEngine   	  = famous.core.Engine
Surface        	  = famous.core.Surface
ContainerSurface  = famous.surfaces.ContainerSurface
Modifier          = famous.core.Modifier
Transform         = famous.core.Transform
Transitionable    = famous.transitions.Transitionable

FamousEngine.setOptions
	appMode: false

if isMobileDevice()
	FamousEngine.setOptions
		fpsCap: 60

rotationAmountTransitionable = new Transitionable(0)
translationAmountTransitionable = new Transitionable(0)
visibleWorldHeightTransitionable = new Transitionable(200)

context = null
render = ->
	last_projectIndex   = parseInt(window.location.hash.split("-")[1])
	if Number.isInteger(last_projectIndex)
		last_rotationAmount = last_projectIndex * (Math.PI / 2) ? 0
		rotationAmountTransitionable.set(last_rotationAmount)

	rootElement = document.getElementById('document-root')
	rootElement.innerHTML = homeTemplate()

	contentContainerModifier = new Modifier()
	contentContainer = new ContainerSurface(
		classes: ["famous-content-container"]
		size: [true, true]
	)
	worldModifier = new Modifier(
		align: [0, 1]
	)
	worldModifier.transformFrom =>
		return Transform.translate(0, -visibleWorldHeightTransitionable.get(), 0)
	worldSurface = new Surface(
		classes: ["world-surface"]
		size: [true, undefined]
		content: """
			<div class="world-container">
				<div class="world-clip">
					<canvas id="stars-container"></canvas>
				</div>
			</div>
	    """
	)
	contentContainer
		.add( worldModifier )
		.add( worldSurface )

	context = FamousEngine.createContext(document.getElementById('famous-root'))
	context
		.add( contentContainerModifier )
		.add( contentContainer )



	onResize = ->
		headerSize    = document.getElementsByClassName("paper-header")[0].offsetHeight
		pageSize      = context.getSize()
		contextHeight = pageSize[1] - headerSize 
		contentContainer.setSize()

		visibleWorldHeight = 200
		if visibleWorldHeight > contextHeight * 0.5
			visibleWorldHeight = contextHeight * 0.5
		visibleWorldHeightTransitionable.set(visibleWorldHeight)
	FamousEngine.on 'resize', onResize
	onResize()

	#Lagometer
	# Lagometer = require("famous-lagometer/Lagometer")
	# lagometerModifier = new Modifier(
	# 	size: [100, 100]
	# 	align: [1.0, 0.0]
	# 	origin: [1.0, 0.0]
	# 	transform: Transform.translate(-30, 0, 100)
	# )
	# lagometer = new Lagometer(size: lagometerModifier.getSize())
	# context.add(lagometerModifier).add(lagometer)

	renderInterval = setInterval (->
		if document.getElementById('stars-container') isnt null
			clearInterval(renderInterval)
			renderStars(
				canvas: document.getElementById('stars-container')
				rotationAmountTransitionable: rotationAmountTransitionable
				# visibleWorldHeightTransitionable: visibleWorldHeightTransitionable
			)
			registerListeners(
				rotationAmountTransitionable: rotationAmountTransitionable
				translationAmountTransitionable: translationAmountTransitionable
			)
			renderProjects(
				container: contentContainer
				rotationAmountTransitionable: rotationAmountTransitionable
				visibleWorldHeightTransitionable: visibleWorldHeightTransitionable
			)
	), 35

cleanup = ->
	cleanupStars()
	cleanupListeners()
	cleanupProjects()
	FamousEngine.deregisterContext(context)
	context = null

export default home = 
	render: render
	cleanup: cleanup