$ ->
	canvas = document.getElementById "arena"
	context = canvas.getContext "2d"
	$canvas = $(canvas)
	context.fillRect 20, 20, 800, 600
