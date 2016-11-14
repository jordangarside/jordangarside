import page from 'page'

import about from '../pages/about/index.coffee'
import computationalChemPaper from '../pages/computational_chem_paper/index.coffee'
import electrochemPaper from '../pages/electrochem_paper/index.coffee'
import home from '../pages/home/index.coffee'
import inlet from '../pages/inlet/index.coffee'
import tesloop from '../pages/tesloop/index.coffee'

# page.base('')

current_path = ""
page('/', (ctx) ->
	if current_path != page.current
		console.log 'Router: Home Route...'
		home.render()
		ga('send', 'pageview')
		current_path = page.current
)

page.exit('/', (ctx, next) ->
	if page.current != "/"
		home.cleanup()
	next()
)

page('/about-me', ->
	if current_path != page.current
		console.log 'Router: About Route...'
		about.render()
		ga('send', 'pageview')
		current_path = page.current
)

page('/electrochemistry', ->
	if current_path != page.current
		console.log 'Router: Electrochem Route...'
		electrochemPaper.render()
		ga('send', 'pageview')
		current_path = page.current
)

page('/inlet', ->
	if current_path != page.current
		console.log 'Router: inlet Route...'
		inlet.render()
		ga('send', 'pageview')
		current_path = page.current
)

page('/tesloop', ->
	if current_path != page.current
		console.log 'Router: tesloop Route...'
		tesloop.render()
		ga('send', 'pageview')
		current_path = page.current
)

page('/computational-chemistry', ->
	if current_path != page.current
		console.log 'Router: tesloop Route...'
		computationalChemPaper.render()
		ga('send', 'pageview')
		current_path = page.current
)

###
router.on(
	'/':
		as: 'home'
		uses: (params, query) ->
			console.log 'Router: Home Route...'
			renderHome()
		hooks:
			before: ->
				console.log 'BEFORE'
	'/about':
		as: 'about'
		uses: (params, query) ->
			console.log 'Router: About Route...'
			rootElement = document.getElementById('document-root')
			rootElement.innerHTML = aboutTemplate()
	'/project/:projectID':
		as: 'project'
		uses: (params, query) ->
			console.log 'Router: Project Route ' + params.projectID + '...'
)
###

# router.on('/',
# 	() -> 
# 		console.log 'home'
# 	,
# 		after: () ->
# 			console.log 'after'
# )

# router.go = (routeName, params, callback) ->
# 	route = router.generate(routeName, params)
# 	router.navigate(route)
# 	if callback? then callback()

document.addEventListener 'WebComponentsReady', ->
	page.start()
#	router.resolve()

router = {}

window.page = page

export default router