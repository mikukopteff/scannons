
connectServer = ->
    window.WebSocket = window.WebSocket || window.MozWebSocket
    connection = new WebSocket('ws://127.0.0.1:1337')
    
    connection.onopen = -> 
        console.log "websocket open"

    connection.onerror = (error) ->
        console.log "error:" + error

    connection.onmessage = (message) ->
        try
            console.log "message received"
            json = JSON.parse message.data
            console.log json
        catch e
            console.log('Not a valid command: ', message.data)
        performCommandAction json

performCommandAction = (command) ->
  switch (command.operation)
    when "shoot" then window.main.pickCannon(command.cannon).shoot()
    when "move" then window.main.pickCannon(command.cannon).move(command.direction, command.amount)
    else throw new Error("Illegal operation from server:" + command.operation)

window.websocket = if not window.websocket? then new Object
window.websocket.connectServer = connectServer