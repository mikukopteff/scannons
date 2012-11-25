
context = 0
canvas = 0
leftCannon = 0
rightCannon = 0
fps = 50

$ ->
    canvas = document.getElementById "arena"
    canvas.style.border = "green 3px solid"
    context = canvas.getContext "2d"
    drawBackground()
    setInterval(draw, 1000 / fps)
    leftCannon = new Cannon(0 + Cannon.margin, canvas.height / 2, "chewie")
    rightCannon = new Cannon((canvas.width - Cannon.margin) - Cannon.width, canvas.height / 2, "luke")
    connectServer()

drawBackground = ->
	drawComponent((() -> context.fillRect 0, 0, canvas.width, canvas.height), "white")

drawComponent = (fun, color) ->
	context.beginPath()
	context.fillStyle = color
	fun.call()
	context.closePath()
	context.fill()

draw = ->
	drawBackground()
	if (rightCannon.ammo) 
	  drawComponent((() -> context.arc rightCannon.ammo.x, rightCannon.ammo.y, Ammo.size, 0, Math.PI * 2, true), "red")
	if (leftCannon.ammo) 
	  drawComponent((() -> context.arc leftCannon.ammo.x, leftCannon.ammo.y, Ammo.size, 0, Math.PI * 2, true), "red") 	
  drawComponent((() -> context.fillRect leftCannon.x, leftCannon.y, Cannon.width, Cannon.height), "black")	
  drawComponent((() -> context.fillRect rightCannon.x, rightCannon.y, Cannon.width, Cannon.height), "black")
  updateShots()
  updateCannonMovement()
  #log()

log = ->
  console.log "Left Cannon x:" + leftCannon.x + " y:" + leftCannon.y
  (console.log " Left Cannon ammo:" + leftCannon.ammo.x + " y:" + leftCannon.ammo.y) if leftCannon.ammo?
  console.log "Right Cannon x:" + rightCannon.x + " y:" + rightCannon.y 
  (console.log "Rigth Cannon ammo:" + rightCannon.ammo.x + " y:" + rightCannon.ammo.y) if rightCannon.ammo?

updateCannonMovement = ->
  updateSingleCannonMovement(leftCannon)
  updateSingleCannonMovement(rightCannon)

updateSingleCannonMovement = (cannon) ->
  if cannon.movesLeftInPixels > 0
    switch (cannon.direction)
      when "s" then moveCannonDown(cannon)
      when "n" then moveCannonUp(cannon)
      else throw new Error("Illegal direction for Cannon:" + cannon.direction)
    cannon.move(cannon.direction, cannon.movesLeftInPixels - Cannon.speed)

moveCannonDown = (cannon) ->
  if ((cannon.y + Cannon.height) > (canvas.height - Cannon.speed)) 
    cannon.y += (canvas.height - (cannon.y + Cannon.height))
  else 
    cannon.y += Cannon.speed

moveCannonUp = (cannon) -> if ((cannon.y) < (0 + Cannon.speed)) then cannon.y -= cannon.y else cannon.y -= Cannon.speed

updateShots = ->
  updateLeftCannonAmmo() if leftCannon.ammo?
  updateRightCannonAmmo() if rightCannon.ammo?

updateLeftCannonAmmo = ->
  if (leftCannon.ammo.x < canvas.width) then leftCannon.ammo.x += Ammo.speed else leftCannon.ammo = null
  if hitTesting(leftCannon.ammo, rightCannon) then console.log "RIGHT CANNON HIT"; leftCannon.ammo = null


updateRightCannonAmmo = ->
  if (rightCannon.ammo.x > 0) then rightCannon.ammo.x -= Ammo.speed else rightCannon.ammo  = null
  if hitTesting(rightCannon.ammo, leftCannon) then console.log ("LEFT CANNON HIT"); rightCannon.ammo = null
	
hitTesting = (ammo, cannon)->
  if ammo?
    if ((ammo.x + Ammo.size / 2 >= cannon.x) and (ammo.x <= cannon.x + Cannon.width) and (ammo.y + Ammo.size / 2 >= cannon.y) and
        (ammo.y <= cannon.y + Cannon.height))
      return true
  else 
    return false

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
  	@ammo = new Ammo(this.x + Cannon.width / 2, this.y + Cannon.height / 2) if not this.ammo?
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
    else throw new Error("Illegal operation from server:" + command.operation)

pickCannon = (name) ->
  if (name is leftCannon.name) then leftCannon else if (name is rightCannon.name) then rightCannon else throw new Error("Bad cannon name")

  
# These have to be refactored to a separate module, if they are even needed
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
	rightCannon.move("n", 10)
	
keyState(40).filter(x).onValue () -> 
	rightCannon.move("s", 10)

keyState(65).filter(x).onValue () -> 
	leftCannon.move("n", 10)
	
keyState(90).filter(x).onValue () -> 
	leftCannon.move("s", 10)
	
keyState(32).filter(x).onValue () ->
	rightCannon.shoot()

keyState(88).filter(x).onValue () ->
	leftCannon.shoot()
	

  
