
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

app.get('/:cannon/:operation', function(req, res){
        performHttpAction();
        console.log('Http request received, cannon:' + req.params.cannon + ' does:' + req.params.operation);
        res.send('Api received a message\n');
});



