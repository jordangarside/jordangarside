	root = global

	phantomjs = Meteor.npmRequire('phantomjs')
	path = Npm.require('path')
	process.env.PATH += ':' + path.dirname(phantomjs.path)