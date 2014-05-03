'use strict'

# setInterval run, 1000 / fps
# setInterval em.fixedUpdate ->
#     console.log \update
# , 20

# setInterval em.fixedUpdate !->
#     console.log \update
# , 1

# setInterval em.fixedUpdate ->
#   console.log \update
# , 3000

# function lel
#     console.log \lel

# (lel `setInterval` 50_000ms) !->
#     console.log \update

# (lel `setInterval` 50_000ms)

# (`setInterval` 1000) <| -> console.log \test

player = em.createEntity!
em.addComponent player, new CPosition <<<
    x: 5
    y: 5
em.addComponent player, new CDrawable <<<
    width: 25
    height: 80
    color: 0xF5901D
    type: CDrawable.Type.RECTANGLE
em.addComponent player, new CInput
em.addComponent player, new CSpeed



bb = new dcodeIO.ByteBuffer!
bb.writeInt16 42
bb.writeInt16 42
bb.writeInt16 42
# console.log bb.length

net.listen \god \localhost, 9000
net.onOpen = onOpen  # TODO : check when not set
# net.onData = onData

position = new CPosition
    ..x = 42
    ..y = 42

position2 = new CPosition
    ..x = 128
    ..y = 128

function onOpen conn
    console.log \onOpen
    net._send position.toArrayBuffer!
    # net._send position2.toArrayBuffer!

function dummy
    console.log

setInterval  ->
    em.fixedUpdate dummy
, 1000 / 60fps
