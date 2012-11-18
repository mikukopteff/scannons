scannons
========

Simple Html5 game that has cannons and is controlled throught the backend node.js http API.
API currently supports shoot and move commands in the following way:

`http://{ip}:{port}/shoot/{playername}` as in `http://localhost:8080/shoot/chewie` 
`http://{ip}:{port}/move/{playername}/{direction}/{amount}` as in `http://localhost:8080/move/luke/n/1`

Cannon names are `luke` and `chewie`.
Directions are `N` and  `S` as in North and South. 

To continuesly compile the client code run `./compile-client` and to test out the server run `node server.js` in the `{APP_ROOT`}/server` -folder
