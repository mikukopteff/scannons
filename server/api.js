
var _ = require('underscore')
var express = require('express');
var app = express();
var httpPort = 8080;
app.use('/public', express.static(_.first(__dirname, _.lastIndexOf(__dirname, '/')).join('') + '/target'));

app.listen(httpPort);
console.log("listening to http at " + httpPort)

var performHttpAction = function(){};

exports.httpAction = function(fun){
    performHttpAction = fun;
}

app.get('/shoot', function(req, res){
        res.send('Api received a message\n');
        console.log(performHttpAction);
        performHttpAction();
});

