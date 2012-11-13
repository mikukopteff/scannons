var WebSocketServer = require('websocket').server;
var http = require('http');
var api = require('./api.js');
api.http()

var port = 1337;
var gameConnection = function(){};

var server = http.createServer(function(request, response) {
    console.log("http request received");
    gameConnection();
    response.end();
});

server.listen(port, function() { console.log("listening to websocket accept " + port) });

wsServer = new WebSocketServer({
    httpServer: server
});


wsServer.on('request', function(request) {
    var connection = request.accept(null, request.origin);
    gameConnection = function() {
        var json = JSON.stringify({ type:'message', data: "movePaddle" });
        connection.sendUTF(json);
    }

    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log("TADAA" + message);
        }
    });

    connection.on('close', function(connection) {
        gameConnection = function(){};
        console.log("Connection closed");
    });
});

