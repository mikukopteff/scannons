'use strict';

var _ = require('underscore');
var express = require('express');
var app = express();
var httpPort = 8080;
app.use('/public', express.static(_.first(__dirname, _.lastIndexOf(__dirname, '/')).join('') + '/target'));

app.listen(httpPort);
console.log("listening to http at " + httpPort);

var performHttpAction = function(commands){};

exports.httpAction = function(fun) {
    performHttpAction = fun;
}

app.get('/move/:cannon/:direction/:amount', function(req, res) {
        console.log('Http request, cannon:' + req.params.cannon + ' moves ' + req.params.amount + ' ' +req.params.direction);
        performHttpAction({operation: 'move', cannon: req.params.cannon, amount: req.params.amount, direction: req.params.direction});
        res.send('Api received a message\n');
});

app.get('/shoot/:cannon', function(req, res) {
        console.log('Http request shoot, cannon:' + req.params.cannon);
        performHttpAction({operation: 'shoot', cannon: req.params.cannon});
        res.send('Api received a message\n');
});