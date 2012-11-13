
exports.http = function(){
	var express = require('express');
	var app = express();
	var httpPort = 8080;

	app.get('/hello', function(req, res){
  		res.send('Shit gets done\n');
	});

	console.log("listening to http at " + httpPort)
	app.listen(httpPort);
}

