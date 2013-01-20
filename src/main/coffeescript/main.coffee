context = 0
canvas = 0
leftCannon = 0
rightCannon = 0
fps = 50
round = 0

$ ->
    canvas = document.getElementById "arena"
    canvas.style.border = "green 3px solid"
    context = canvas.getContext "2d"
    drawBackground()
    setInterval(draw, 1000 / fps)
    leftCannon = new Cannon(0 + Cannon.margin, canvas.height / 2, window.main.leftPlayer)
    rightCannon = new Cannon((canvas.width - Cannon.margin) - Cannon.width, canvas.height / 2, window.main.rightPlayer)
    drawScoreboard()
    window.websocket.connectServer()

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

drawScoreboard = ->
    $("#right .player").text(window.main.rightPlayer)
    $("#right .score").text(0)
    $("#left .score").text(0)
    $("#left .player").text(window.main.leftPlayer)  

log = ->
  console.log "Left Cannon x:" + leftCannon.x + " y:" + leftCannon.y
  (console.log "Left Cannon ammo:" + leftCannon.ammo.x + " y:" + leftCannon.ammo.y) if leftCannon.ammo?
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
  if hitTesting(leftCannon.ammo, rightCannon) then console.log "RIGHT CANNON HIT"; updateLeftScore(); leftCannon.ammo = null


updateRightCannonAmmo = ->
  if (rightCannon.ammo.x > 0) then rightCannon.ammo.x -= Ammo.speed else rightCannon.ammo  = null
  if hitTesting(rightCannon.ammo, leftCannon) then console.log ("LEFT CANNON HIT"); updateRightScore(); rightCannon.ammo = null
	
updateLeftScore = ->
    $("#left .score").text(parseInt($("#left .score").text()) + 1)
#copy paste because coffeescript compiler has a bug
updateRightScore = ->
    $("#right .score").text(parseInt($("#right .score").text()) + 1)
    

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
  @speed: 20

pickCannon = (name) ->
  if (name is leftCannon.name) then leftCannon else if (name is rightCannon.name) then rightCannon else throw new Error("Bad cannon name")
 	
window.main = if not window.main? then new Object
window.main.pickCannon = pickCannon
window.main.leftPlayer = "chewie"
window.main.rightPlayer = "luke"
window.main.arena = { width: canvas.width , height: canvas.height }