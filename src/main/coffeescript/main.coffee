x = 150
y = 150
context = 0
canvas = 0

$ ->
	canvas = document.getElementById "arena"
	context = canvas.getContext "2d"
	$canvas = $(canvas)
	context.fillStyle = "black"
	context.fillRect 20, 20, canvas.width, canvas.height
	
	setInterval(draw, 10)

clearGameArea = ->
  context.fillStyle = "black"
	context.fillRect 20, 20, canvas.width, canvas.height

draw = ->
	clearGameArea()
	context.beginPath()
	context.fillStyle = "white"
	context.arc x, y, 10, 0, Math.PI*2, true 
	context.closePath()
	context.fill()
	x += 5
	y += 0

cannon = 
  width: 10
  height: 20
  x: canvas.height