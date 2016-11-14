import aboutTemplate from './index.handlebars'

render = ->
	rootElement = document.getElementById('document-root')
	rootElement.innerHTML = aboutTemplate()

cleanup = ->
	return

export default electrochemPaper =
	render: render
	cleanup: cleanup