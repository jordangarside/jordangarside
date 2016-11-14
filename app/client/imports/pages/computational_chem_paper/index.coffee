import aboutTemplate from './index.handlebars'

render = ->
	rootElement = document.getElementById('document-root')
	rootElement.innerHTML = aboutTemplate()

cleanup = ->
	return

export default computationalChemPaper =
	render: render
	cleanup: cleanup