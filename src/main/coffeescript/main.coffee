
context = 0
canvas = 0
leftCannon = 0
rightCannon = 0
fps = 50
screenUpdateFrequency = 1000 / fps

$ ->
    canvas = document.getElementById "arena"
    context = canvas.getContext "2d"
    drawBackground()
    setInterval(draw, screenUpdateFrequency)
    leftCannon = new Cannon(0 + Cannon.margin, canvas.height / 2, "chewie")
    rightCannon = new Cannon((canvas.width - Cannon.margin) - Cannon.width, canvas.height / 2, "luke")
    connectServer()

drawBackground = ->
	drawComponent((() -> context.fillRect 0, 0, canvas.width, canvas.height), "black")

drawComponent = (fun, color) ->
	context.beginPath()
	context.fillStyle = color
	fun.call()
	context.closePath()
	context.fill()

draw = ->
	drawBackground()
	if (rightCannon.ammo) 
	  drawComponent((() -> context.arc rightCannon.ammo.x, rightCannon.ammo.y, Ammo.size, 0, Math.PI*2, true), "white")
	if (leftCannon.ammo) 
	  drawComponent((() -> context.arc leftCannon.ammo.x, leftCannon.ammo.y, Ammo.size, 0, Math.PI*2, true), "white") 	
  drawComponent((() -> context.fillRect leftCannon.x, leftCannon.y, Cannon.width, Cannon.height), "white")	
  drawComponent((() -> context.fillRect rightCannon.x, rightCannon.y, Cannon.width, Cannon.height), "pink")
  updateShots()
  updateCannonMovement()

updateCannonMovement = ->
  updateSingleCannonMovement(leftCannon)
  updateSingleCannonMovement(rightCannon)

updateSingleCannonMovement = (cannon) ->
  if cannon.movesLeftInPixels > 0
    console.log ("before: " + cannon.movesLeftInPixels)
    switch (cannon.direction)
      when "s" then cannon.y += Cannon.speed
      when "n" then cannon.y -= Cannon.speed
      else throw new Error("Illegal direction for Cannon:" + cannon.direction)
    cannon.move(cannon.direction, cannon.movesLeftInPixels - Cannon.speed)

updateShots = ->
  leftCannon.ammo.x += Ammo.speed if leftCannon.ammo?
  rightCannon.ammo.x -= Ammo.speed if rightCannon.ammo?

	
class Movable
  constructor: (@x, @y) ->

class Cannon extends Movable
  constructor: (x, y, @name) ->
    super(x, y)
  @width: 30
  @height: 75
  @margin: 5
  @speed: 3
  shoot: ->
  	@ammo =  new Ammo(this.x + Cannon.width / 2, this.y + Cannon.height / 2)
  move: (direction, amount) ->
    @movesLeftInPixels = amount
    @direction = direction

class Ammo extends Movable
  constructor: (x, y) ->
    super(x, y)
  @size: 5
  @speed: 10


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
    when "shoot" then pickCannon(command.cannon).shoot()
    when "move" then pickCannon(command.cannon).move(command.direction, command.amount)
    else throw new Error("Illegal operation from server" + command.operation)

pickCannon = (name) ->
  if (name is leftCannon.name) then leftCannon else if (name is rightCannon.name) then rightCannon else throw new Error("Bad cannon name")
  
# These have to be refactored to a separate class, if they are even needed
allKeyUps = $(document).asEventStream "keyup"
allKeyDowns = $(document).asEventStream "keydown"
	
always = (value) ->
    (_) ->
      value
      
keyCodeIs = (keyCode) ->
    (event) ->
      event.keyCode is keyCode
      
keyUps = (keyCode) ->
    allKeyUps.filter keyCodeIs(keyCode)
keyDowns = (keyCode) ->
    allKeyDowns.filter keyCodeIs(keyCode)
    
keyState = (keyCode) ->
    keyDowns(keyCode).map(always(true)).merge(keyUps(keyCode).map(always(false))).toProperty false
    
x = (y)->y

keyState(38).filter(x).onValue () -> 
	rightCannon.y -= Cannon.speed
	
keyState(40).filter(x).onValue () -> 
	rightCannon.y += Cannon.speed

keyState(65).filter(x).onValue () -> 
	leftCannon.y -= Cannon.speed
	
keyState(90).filter(x).onValue () -> 
	leftCannon.y += Cannon.speed
	
keyState(32).filter(x).onValue () ->
	rightCannon.shoot()

keyState(88).filter(x).onValue () ->
	leftCannon.shoot()
	
$(document).asEventStream('keydown').subscribe (evt) ->
	console.log "Debugging key events" + evt.value.keyCode	

  
