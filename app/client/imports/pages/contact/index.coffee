import contactTemplate from './index.handlebars'

render = ->
	rootElement = document.getElementById('document-root')
	rootElement.innerHTML = contactTemplate()

cleanup = ->
	return

export default contact =
	render: render
	cleanup: cleanup