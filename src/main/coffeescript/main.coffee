x = 50
y = 50
context = 0
canvas = 0
leftCannon = 0
rightCannon = 0

$ ->
	canvas = document.getElementById "arena"
	context = canvas.getContext "2d"
	drawBackground()
	setInterval(draw, 10)
	leftCannon = new Cannon(0 + Cannon.margin, canvas.height / 2)
	rightCannon = new Cannon((canvas.width - Cannon.margin) - Cannon.width, canvas.height / 2)

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
	drawComponent((() -> context.arc x, y, 5, 0, Math.PI*2, true), "white") 	
	drawComponent((() -> context.fillRect leftCannon.x, leftCannon.y, Cannon.width, Cannon.height), "white")	
	drawComponent((() -> context.fillRect rightCannon.x, rightCannon.y, Cannon.width, Cannon.height), "white")
	x += 5
	y += 0

class Movable
  constructor: (@x, @y) ->

class Cannon extends Movable
  constructor: (x, y) ->
    super(x, y)
  @width: 30
  @height: 75
  @margin: 5

class Ammo extends Movable
	constructor: (x, y) ->
		super(x, y)
	@size: 10
	