var express = require('express');
var app = express();
var PORT = 3000;
if (process.env.NODE_ENV == "production"){
	PORT = 80;
}
app.use(express.static('public'))
app.use('/:page', express.static('public/index.html'))

app.listen(PORT, function() { console.log('Listening on port ' + PORT + '...') });