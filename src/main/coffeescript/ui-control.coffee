context = 0

init = (arenaContext) ->
  context = arenaContext

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
    if (window.main.rightCannon.ammo) 
      drawComponent((() -> context.arc window.main.rightCannon.ammo.x, window.main.rightCannon.ammo.y, Ammo.size, 0, Math.PI * 2, true), "red")
    if (window.main.leftCannon.ammo) 
      drawComponent((() -> context.arc window.main.leftCannon.ammo.x, window.main.leftCannon.ammo.y, Ammo.size, 0, Math.PI * 2, true), "red")   
  drawComponent((() -> context.fillRect window.main.leftCannon.x, window.main.leftCannon.y, Cannon.width, Cannon.height), "black")  
  drawComponent((() -> context.fillRect window.main.rightCannon.x, window.main.rightCannon.y, Cannon.width, Cannon.height), "black")
  updateShots()
  updateCannonMovement()
  #log()

log = ->
  console.log "Left Cannon x:" + window.main.leftCannon.x + " y:" + window.main.leftCannon.y
  (console.log "Left Cannon ammo:" + window.main.leftCannon.ammo.x + " y:" + window.main.leftCannon.ammo.y) if window.main.leftCannon.ammo?
  console.log "Right Cannon x:" + window.main.rightCannon.x + " y:" + window.main.rightCannon.y 
  (console.log "Rigth Cannon ammo:" + window.main.rightCannon.ammo.x + " y:" + window.main.rightCannon.ammo.y) if window.main.rightCannon.ammo?

updateCannonMovement = ->
  updateSingleCannonMovement(window.main.leftCannon)
  updateSingleCannonMovement(window.main.rightCannon)

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
  updateLeftCannonAmmo() if window.main.leftCannon.ammo?
  updateRightCannonAmmo() if window.main.rightCannon.ammo?

updateLeftCannonAmmo = ->
  if (window.main.leftCannon.ammo.x < canvas.width) then window.main.leftCannon.ammo.x += Ammo.speed else window.main.leftCannon.ammo = null
  if hitTesting(window.main.leftCannon.ammo, window.main.rightCannon) then console.log "RIGHT CANNON HIT"; window.main.leftCannon.ammo = null


updateRightCannonAmmo = ->
  if (window.main.rightCannon.ammo.x > 0) then window.main.rightCannon.ammo.x -= Ammo.speed else window.main.rightCannon.ammo  = null
  if hitTesting(window.main.rightCannon.ammo, window.main.leftCannon) then console.log ("LEFT CANNON HIT"); window.main.rightCannon.ammo = null
    
hitTesting = (ammo, cannon)->
  if ammo?
    if ((ammo.x + Ammo.size / 2 >= cannon.x) and (ammo.x <= cannon.x + Cannon.width) and (ammo.y + Ammo.size / 2 >= cannon.y) and
        (ammo.y <= cannon.y + Cannon.height))
      return true
  else 
    return false

window.uiControl = if not window.uiControl? then new Object
window.uiControl.init = init
window.uiControl.draw = draw
window.uiControl.drawBackground = drawBackground
