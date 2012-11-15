var sendMessageToGame = function(){console.log('empty function')};

var _ = require('underscore')
var express = require('express');
var app = express();
var httpPort = 8080;
app.use('/public', express.static(_.first(__dirname, _.lastIndexOf(__dirname, '/')).join('') + '/target'));
console.log(_.first(__dirname, _.lastIndexOf(__dirname, '/')).join('') + '/target');

app.listen(httpPort);
console.log("listening to http at " + httpPort)

app.get('/shoot', function(req, res){
    res.send('Api received a message\n');
    console.log(sendMessageToGame);
    sendMessageToGame();
});

var websocketPort = 1337;
var gameSocketServer = require('websocket').server;
var http = require('http');
var server = http.createServer(function(){});
server.listen(websocketPort, function() { console.log('listening to websocket accept ' + websocketPort) });
gameSocketServer = new gameSocketServer({ httpServer: server });

gameSocketServer.on('request', function(request) {
    var connection = request.accept(null, request.origin);
    sendMessageToGame = function() {
        console.log('writing data out to game');
        var json = JSON.stringify({ type:'message', data: 'shoot' });
        connection.sendUTF(json);
    }

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log('message received' + message);
        }
    });

    connection.on('close', function(connection) {
        sendMessageToGame = function(){};
        console.log('Connection closed');
    });
});

