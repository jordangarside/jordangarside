import * as famous from 'famous'

import router from './imports/router/index.coffee'
import './index.sass'

console.log famous

FamousEngine   	  = famous.core.Engine
Surface        	  = famous.core.Surface
ContainerSurface  = famous.surfaces.ContainerSurface
Modifier          = famous.core.Modifier
Transform         = famous.core.Transform
Transitionable    = famous.transitions.Transitionable

TweenTransition	  = famous.transitions.TweenTransition
EasingTransitions = famous.transitions.Easing
SpringTransition  = famous.transitions.SpringTransition
WallTransition	  = famous.transitions.WallTransition
SnapTransition    = famous.transitions.SnapTransition

#Register Tween Transitions
TweenTransition.registerCurve('inOutCubic', EasingTransitions.inOutCubic)

#Register Physics Methods
Transitionable.registerMethod('spring', SpringTransition)
Transitionable.registerMethod('wall', WallTransition)
Transitionable.registerMethod('snap', SnapTransition)