connectServer = ->
    window.WebSocket = window.WebSocket || window.MozWebSocket
    connection = new WebSocket('ws://127.0.0.1:1337')
    
    connection.onopen = -> 
        console.log "websocket open"
        setInterval((() -> statusUpdate(connection)), 200)
        $("#statusbar").text("Connected to server")

    connection.onerror = (error) ->
        console.log "error:" + error
        $("#statusbar").text("Disconnectd from server!")

    connection.onmessage = (message) ->
        try
            console.log "message received"
            json = JSON.parse message.data
            console.log json
        catch e
            console.log('Not a valid command: ', message.data)
            $("#statusbar").text("Error in game message! Plz check logs!")
        performCommandAction json
        connection.send JSON.stringify createStatusObject()
        $("#statusbar").text(JSON.stringify json)

performCommandAction = (command) ->
  switch (command.operation)
    when "shoot" then window.main.pickCannon(command.cannon).shoot()
    when "move" then window.main.pickCannon(command.cannon).move(command.direction, command.amount)
    else throw new Error("Illegal operation from server:" + command.operation)

createStatusObject = ->
    {leftCannon: window.main.pickCannon(window.main.leftPlayer), 
    rightCannon: window.main.pickCannon(window.main.rightPlayer), arena: window.main.arena}

statusUpdate

statusUpdate = (conn) ->
    conn.send JSON.stringify createStatusObject()


window.websocket = if not window.websocket? then new Object
window.websocket.connectServer = connectServer