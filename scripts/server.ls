'use strict'

export em = new EntityManager "server"
net.listen \god \localhost 9000
net.onOpen = onOpen

function onInput event
    console.log event.key_up

em.registerEvent(INPUT, onInput)

position = new CPosition <<<
    x: 10
    y: 10


bb = new dcodeIO.ByteBuffer
# console.log position
# position.decode bb, 4
bb.writeInt8(0)
mark = bb.offset
posenc = position.encode!
bb.append posenc
bb.offset = mark + posenc.length

console.log bb.toColumns!

bb.writeInt8(0)
mark = bb.offset
posenc = position.encode!
bb.append posenc
bb.offset = mark + posenc.length

console.log bb.toColumns!

bb.flip!
console.log bb.toColumns!
console.log \length_ + bb.length
console.log \offset_ + bb.offset
bb.readInt8!
console.log bb.toColumns!
# bb.reverse!
# bb.BE!
pos2 = CPosition.decode bb

console.log bb.toColumns!
pos2
    console.log ..x
    console.log ..y

# player = net.createEntity!
# net.addComponent player, new CPosition <<<
#     x: 10
#     y: 10
# net.addComponent player, new CPosition <<<
#     x: 10
#     y: 10

# net.sendEvent new CPosition <<<
#     x: 42
#     y: 42

# net.sendEvent new CPosition <<<
#     x: 42
#     y: 42



# net.output.flip!
# console.log \WWWOWOWOW
# # console.log net.output.toColumns!
# net.input = net.output
# net.readMessage!


function onOpen conn

    console.log \onOpen
    # player = net.create PLAYER
    # pos = player.get CPosition
    # pos.x = 300px

    # player = net.createEntity!
    # net.addComponent player, new CPosition <<<
    #     x: 10
    #     y: 10
    # # net.addComponent player, new CPosition <<<
    # #     x: 10
    # #     y: 10

    # net.sendEvent new CPosition <<<
    #     x: 42
    #     y: 42


    # net.sendEvent new INPUT <<<
    #     key_up: true
    #     key_down: true
    #     key_left: true
    #     key_right: true
    #     entity_id: 0

    # net.removeComponent player, CPosition

    # entity = net.createEntity!
    # net.addComponent entity, new CPosition <<<
    #     x: 5
    #     y: 5
    # net.addComponent entity, new CDrawable <<<
    #     width: 25
    #     height: 80
    #     color: 0xF5901D
    #     type: CDrawable.Type.RECTANGLE


function dummy
    console.log

paddleAutoControllerSystem = new PaddleAutoControllerSystem

setInterval  ->
    em.fixedUpdate dummy
    # em.fixedUpdate ->
        # paddleAutoControllerSystem.loop!
, 1000ms / 60fps
