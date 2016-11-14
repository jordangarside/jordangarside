window.jordan ?= {}

eventSeparation			= Math.PI / 2
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
jordan.imageSize			= [180, 120] # [180, 120]
jordan.marginTwo			= 10
jordan.descriptionSize		= [150, 50]
jordan.marginOne			= 30
jordan.worldHeightShowing	= 200

jordan.imageYOffset		= (200 + jordan.marginOne)

import * as famous from 'famous'
import page from 'page'
import * as _ from 'lodash'

import router from '../../../router/index.coffee'

FamousEngine     = famous.core.Engine
Surface          = famous.core.Surface
ContainerSurface = famous.surfaces.ContainerSurface
Modifier         = famous.core.Modifier
RenderController = famous.views.RenderController
Transitionable   = famous.transitions.Transitionable
Transform        = famous.core.Transform

export projects = [
	title: "about me"
	imageURL: "/images/animations/graduation.gif"
	URL: "/about-me"
,
	title: "electrochem paper"
	imageURL: "/images/animations/junction.gif"
	URL: "/electrochemistry"
,
	title: "inlet"
	imageURL: "/images/animations/inlet.gif"
	URL: "/inlet"
,
	title: "tesloop"
	imageURL: "/images/animations/error.gif"
	URL: "/tesloop"
,
	title: "computational chem paper"
	imageURL: "/images/animations/school.gif"
	URL: "/computational-chemistry"
]

twoPi			= 6.2832 # 2 * Math.PI
piOverFour		= 0.7853982 # Math.PI / 4
piOverFive		= 0.62832 # Math.PI / 5
sevenPiOverFour	= 5.497787 # 7 * Math.PI / 4
ninePiOverFive	= 5.6549 # 9 * Math.PI / 5

rotationListener = null

export renderProjects = ({container, rotationAmountTransitionable, visibleWorldHeightTransitionable}) ->
	_projects = _.cloneDeep(projects)
	_.each _projects, (project, index) ->
		if not _projects[index].created?
			_projects[index].created	= true
			_projects[index].enabled	= false
			projectRenderController	= new RenderController
				inTrasition:
					curve: 'linear'
					duration: 0
				outTransition:
					curve: 'linear'
					duration: 0
				overlap: true
			pictureSize = _projects[index].size ? jordan.imageSize

			projectContainerModifier	= new Modifier
				size: [undefined, undefined]
			projectContainerSurface 	= new ContainerSurface
				classes: ["life-event-container"]
			projectContainerModifier.sizeFrom ->
				return jordan.boxSize

			imageModifier	= new Modifier
				# align: [0.5, 1]
				origin: [0.5, 1]
			imageSurface 	= new Surface
				size: [180, 120]
				classes: ["image-container"]
				content: "
					<img src='#{_projects[index].imageURL}' width='100%' height='100%' style=''>
				"
				properties:
					backfaceVisibility: "visible"
					textAlign:			"center"

			rotationXModifier	= new Modifier()
			rotationYModifier	= new Modifier()
	
			projectContainer = projectContainerSurface
			projectContainer.add(imageModifier).add(imageSurface)

			#Enable LifeEvent
			_projects[index].enable = (options) ->
				if not _projects[index].enabled
					_projects[index].enabled = true
					#Start Transform and Show Surface
					@topThetaValue				= index * Math.PI / 2
					@currentThetaTransitionable	= rotationAmountTransitionable

					imageModifier.transformFrom =>
						visibleWorldHeight = visibleWorldHeightTransitionable.get()
						if visibleWorldHeight < 75
							imageSurface.setSize([120, 80])
						else
							imageSurface.setSize([180, 120])
						return Transform.translate(0, -( visibleWorldHeight + jordan.marginOne ), 0)

					rotationXModifier.transformFrom =>
						thetaOffset = @topThetaValue - @currentThetaTransitionable.get()
						return Transform.rotateZ(thetaOffset)
					rotationYModifier.transformFrom =>
						thetaTransitionable = @currentThetaTransitionable.get()
						thetaOffset = Math.abs((@topThetaValue - thetaTransitionable)) - (twoPi * (Math.floor(thetaTransitionable / (twoPi))))
						#console.log "Index: #{index}, thetaOffset: #{thetaOffset}"
						switch
							when -(piOverFive) < thetaOffset <= 0
								return Transform.rotateY(-thetaOffset)
							when (ninePiOverFive) < thetaOffset <= twoPi
								return Transform.rotateY((twoPi - thetaOffset))
							when 0 < thetaOffset < piOverFive
								return Transform.rotateY(thetaOffset)
							else
								return Transform.rotateY(piOverFive)
					projectRenderController.show(projectContainerSurface, {curve: "linear", duration: 0})

			_projects[index].enable()
			#Disable LifeEvent
			_projects[index].disable = ->
				if _projects[index].enabled
					console.log "project #{index}: Hiding..."
					_projects[index].enabled = false
					#Stop Transforms and Hide Surface
					rotationXModifier.transformFrom()
					rotationYModifier.transformFrom()
					projectRenderController.hide()
			container
				.add(
					new Modifier
						align: [0.5, 1]
				)
				.add(rotationYModifier)
				.add(rotationXModifier)
				.add(projectContainerModifier)
				.add(projectRenderController)

			_projects[index].expand = (callback) ->
				jordan.showBackButton()
				_projects[index].expanded = true
				jordan.disableDragEvents()
				doExpand = =>
					_projects[index - 1]?.disable()
					_projects[index + 1]?.disable()

					projectContainerSurface.addClass('expanded')

					#Date
					dateTranslationTransitionable	= new Transitionable [0, jordan.dateYOffset, 0]
					dateOriginTransitionable 		= new Transitionable [0.5, 1]

					dateModifier.transformFrom ->
						dateTranslation = dateTranslationTransitionable.get()
						return Transform.translate(dateTranslation[0], dateTranslation[1], dateTranslation[2])
					dateModifier.originFrom ->
						return dateOriginTransitionable.get()
					dateModifier.alignFrom ->
						return dateOriginTransitionable.get()

					dateTranslationTransitionable.set([jordan.expandedDateOffsets[0], jordan.expandedDateOffsets[1], 0], expandTransition)
					dateOriginTransitionable.set([0, 0], expandTransition)
					
					#Header
					headerTranslationTransitionable = new Transitionable [0, jordan.headerYOffset, 0]
					headerOriginTransitionable 		= new Transitionable [0.5, 1]
					headerSizeTransitionable		= new Transitionable jordan.headerSize

					headerModifier.transformFrom ->
						headerTranslation = headerTranslationTransitionable.get()
						return Transform.translate(headerTranslation[0], headerTranslation[1], headerTranslation[2])
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
					imageTranslationTransitionable 	= new Transitionable [0, 0, 0]
					imageOriginTransitionable 		= new Transitionable [0.5, 1]

					imageModifier.transformFrom ->
						imageTranslation = imageTranslationTransitionable.get()
						return Transform.translate(imageTranslation[0], imageTranslation[1], 0)
					imageModifier.originFrom ->
						return imageOriginTransitionable.get()
					imageModifier.alignFrom ->
						return imageOriginTransitionable.get()

					imageTranslationTransitionable.set([jordan.expandedImageOffsets[0], jordan.expandedImageOffsets[1], 0], expandTransition)
					imageOriginTransitionable.set([1, 1], expandTransition)

					#Description
					descriptionTranslationTransitionable 	= new Transitionable [0, jordan.descriptionYOffset, 0]
					descriptionOriginTransitionable 		= new Transitionable [0.5, 1]
					descriptionSizeTransitionable			= new Transitionable jordan.descriptionSize

					descriptionModifier.transformFrom	->
						descriptionTranslation	= descriptionTranslationTransitionable.get()
						return Transform.translate(descriptionTranslation[0], descriptionTranslation[1], 0)
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
				if Math.abs(rotationAmountTransitionable.get() - (index * Math.PI / 2)) > Math.PI / 4
					rotationAmountTransitionable.halt()
					rotationAmountTransitionable.set(index * Math.PI / 2,
						curve: 'inOutCubic'
						duration: 1200
					, ->
						doExpand()
					)
				else
					doExpand()

			_projects[index].close = (callback) ->
				projectContainerSurface.removeClass('expanded')

				#Date
				dateTranslationTransitionable	= new Transitionable([jordan.expandedDateOffsets[0], jordan.expandedDateOffsets[1], 0])
				dateOriginTransitionable		= new Transitionable [0, 0]
	
				dateModifier.transformFrom ->
					dateTranslation = dateTranslationTransitionable.get()
					return Transform.translate(dateTranslation[0], dateTranslation[1], dateTranslation[2])
				dateModifier.originFrom ->
					return dateOriginTransitionable.get()
				dateModifier.alignFrom ->
					return dateOriginTransitionable.get()

				dateTranslationTransitionable.set([0, jordan.dateYOffset, 0], expandTransition)
				dateOriginTransitionable.set([0.5, 1], expandTransition)

				#Header
				headerTranslationTransitionable	= new Transitionable [jordan.expandedHeaderOffsets[0], jordan.expandedHeaderOffsets[1], 0]
				headerOriginTransitionable		= new Transitionable [0, 0]
				headerSizeTransitionable		= new Transitionable [(jordan.boxSize[0] - jordan.expandedHeaderOffsets[0] - 20), jordan.headerSize[1]]

				headerModifier.transformFrom ->
					headerTranslation = headerTranslationTransitionable.get()
					return Transform.translate(headerTranslation[0], headerTranslation[1], headerTranslation[2])
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
				imageTranslationTransitionable    = new Transitionable([jordan.expandedImageOffsets[0], jordan.expandedImageOffsets[1], 0])
				imageOriginTransitionable		= new Transitionable [1, 1]

				imageModifier.transformFrom ->
					imageTranslation = imageTranslationTransitionable.get()
					return Transform.translate(imageTranslation[0], imageTranslation[1], imageTranslation[2])
				imageModifier.originFrom ->
					return imageOriginTransitionable.get()
				imageModifier.alignFrom ->
					return imageOriginTransitionable.get()

				imageTranslationTransitionable.set([0, 0, 0], expandTransition)
				imageOriginTransitionable.set([0.5, 1], expandTransition)

				#Description
				descriptionTranslationTransitionable	= new Transitionable([jordan.expandedDescriptionOffsets[0], jordan.expandedDescriptionOffsets[1], 0])
				descriptionOriginTransitionable			= new Transitionable [0, 0]
				descriptionSizeTransitionable			= new Transitionable [(jordan.boxSize[0] - 2*jordan.expandedDescriptionOffsets[0]), jordan.descriptionSize[1]]

				descriptionModifier.transformFrom ->
					descriptionTranslation = descriptionTranslationTransitionable.get()
					return Transform.translate(descriptionTranslation[0], descriptionTranslation[1], descriptionTranslation[2])
				descriptionModifier.originFrom ->
					return descriptionOriginTransitionable.get()
				descriptionModifier.alignFrom ->
					return descriptionOriginTransitionable.get()
				descriptionModifier.sizeFrom ->
					return descriptionSizeTransitionable.get()

				descriptionTranslationTransitionable.set([0, jordan.descriptionYOffset, 0], expandTransition)
				descriptionOriginTransitionable.set([0.5, 1], expandTransition)
				descriptionSizeTransitionable.set(jordan.descriptionSize, expandTransition)

				###
				Move Stars/World down for event opening
				jordan.starsTranslation.set [0, -jordan.worldHeightShowing, 0], expandTransition, ->
					_projects[index - 1]?.enable()
					_projects[index + 1]?.enable()
					_projects[index].expanded = false
					jordan.enableDragEvents()
					jordan.hideBackButton()
				###

			# Events
			imageSurface.on "click", _.throttle ((event) ->
				console.log index
				if not _projects[index].expanded
					###
					if index == 0
						page("/about")
					else
						page("/project/#{index}")
					###
					page(_projects[index].URL)
			), 1000
	# Render Events on the Fly
	lastRotationValue 	= null
	lastClosestProject  = null
	rotationListener = ->
		newRotationValue = rotationAmountTransitionable.get()
		if newRotationValue isnt lastRotationValue
			lastRotationValue 	= newRotationValue
			#Find Closest Event
			smallestCloseProject 		= Math.floor(newRotationValue / eventSeparation)
			smallestCloseProjectTheta	= smallestCloseProject * eventSeparation
			largestCloseProject 		= smallestCloseProject + 1
			largestCloseProjectTheta	= smallestCloseProjectTheta + eventSeparation
			if Math.abs(newRotationValue - smallestCloseProjectTheta) > Math.abs(newRotationValue - largestCloseProjectTheta)
				closestProject = largestCloseProject
			else
				closestProject = smallestCloseProject
			# Hide events not +/- 1 from the closest event
			if lastClosestProject isnt closestProject
				lastClosestProject = closestProject
				for project, index in _projects
					if index >= closestProject - 1 and index <= closestProject + 1
						_projects[index]?.enable
							currentThetaTransitionable: rotationAmountTransitionable
					else
						_projects[index]?.disable()
				# Set the hashbang to the closest event
				history.replaceState(undefined, undefined, "#index-#{closestProject}")

	FamousEngine.on 'prerender', rotationListener


export cleanupProjects = ->
	console.log 'Projects: Cleaning up...'
	FamousEngine.removeListener 'prerender', rotationListener

jordan.closeEvent = (callback) ->
	jordan.hideBackButton()
	if jordan.eventExpanded()
		project 	= _.findWhere(_projects, {expanded: true})
		project.close(callback)
	else
		callback()

jordan.eventExpanded = ->
	project 	= _.findWhere(_projects, {expanded: true})
	if project?
		return true
	else
		return false