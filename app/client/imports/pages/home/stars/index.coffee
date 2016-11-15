import * as famous from 'famous'
import * as THREE from 'three'
import * as _ from 'lodash'

FamousEngine   = famous.core.Engine

render = null
export renderStars = ({ canvas, rotationAmountTransitionable }) =>
	if window.screen.width > window.screen.height
		largerScreenDimension	= window.screen.width
		smallerScreenDimension	= window.screen.height
	else
		largerScreenDimension	= window.screen.height
		smallerScreenDimension	= window.screen.width
	canvasWidth		= largerScreenDimension
	canvasHeight	= 210

	if canvasHeight > largerScreenDimension * 0.4
		canvasHeight = largerScreenDimension * 0.4

	threeCanvas			= canvas
			
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

		materials[index] = new THREE.PointsMaterial
			size: size

		particles = new THREE.Points( geometry, materials[index] )

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
		for object, index in scene.children
			if object instanceof THREE.Points
				object.rotation.y = time * if index < 4 then index + 1 else -(index + 1)
				#Appear to rotate world by rotating stars
				object.rotation.x = -rotationAmountTransitionable.get()

		for material, index in materials
			color = parameters[index][0]
			h = ( 360 * ( color[0] + time ) % 360 ) / 360
			material.color.setHSL( h, color[1], color[2] )
			
		renderer.render( scene, camera )
	FamousEngine.on( 'prerender', render )

export cleanupStars = ->
	console.log "Stars: Cleaning up..."
	FamousEngine.removeListener 'prerender', render