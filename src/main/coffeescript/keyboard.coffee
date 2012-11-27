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
    window.main.pickCannon(window.main.rightPlayer).move("n", 10)
    
keyState(40).filter(x).onValue () -> 
    window.main.pickCannon(window.main.rightPlayer).move("s", 10)

keyState(65).filter(x).onValue () -> 
    window.main.pickCannon(window.main.leftPlayer).move("n", 10)
    
keyState(90).filter(x).onValue () -> 
    window.main.pickCannon(window.main.leftPlayer).move("s", 10)
    
keyState(32).filter(x).onValue () ->
    window.main.pickCannon(window.main.rightPlayer).shoot()

keyState(88).filter(x).onValue () ->
    window.main.pickCannon(window.main.leftPlayer).shoot()

