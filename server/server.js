'use strict';

var noClient = function(){console.log('No client connected - nowhere to push data')};
var api = require('./api.js')
api.httpAction(noClient);

var websocketPort = 1337;
var gameSocketServer = require('websocket').server;
var http = require('http');
var server = http.createServer(function(){});
server.listen(websocketPort, function() { console.log('listening to websocket accept ' + websocketPort) });
gameSocketServer = new gameSocketServer({ httpServer: server });

var gameState = {empty:"jee"}

exports.status = gameState;

gameSocketServer.on('request', function(request) {
    var connection = request.accept(null, request.origin);
    var clientConnected = function(commands) {
        console.log('writing data out to game');
        var json = JSON.stringify(commands);
        connection.sendUTF(json);
    }
    console.log('browser client connected');
    api.httpAction(clientConnected);

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log('message received:' + message);
            console.log (message.utf8Data)
            gameState = JSON.parse(message.utf8Data);
        }
    });

    connection.on('close', function(connection) {
        api.httpAction(noClient);
        console.log('Connection closed');
    });
});

