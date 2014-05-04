'use strict'

export em = new EntityManager "server"
net.listen \god \localhost 9000
net.onOpen = onOpen

function onInput event
    console.log event.key_up

em.registerEvent(INPUT, onInput)


function onOpen conn

    console.log \onOpen
    player = net.create PLAYER, true
    pos = player.get CPosition
    pos.x = 300px

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
