x = 50
y = 50
context = 0
canvas = 0

$ ->
	canvas = document.getElementById "arena"
	context = canvas.getContext "2d"
	$canvas = $(canvas)
	drawComponent((() -> context.fillRect 0, 0, canvas.width, canvas.height), "black")	
	setInterval(draw, 10)

drawComponent = (fun, color) ->
	context.beginPath()
	context.fillStyle = color
	fun.call()
	context.closePath()

draw = ->
	drawComponent((() -> context.fillRect 40, 0, canvas.width - 80, canvas.height), "green") 
	drawComponent((() -> context.arc x, y, 10, 0, Math.PI*2, true), "white") 
	context.fill()
	drawComponent((() -> context.fillRect 0, cannon.location , cannon.width, cannon.height), "yellow")
	context.fill()
	x += 5
	y += 0

cannon = 
  width: 10
  height: 50
  location: 0