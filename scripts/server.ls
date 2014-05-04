'use strict'


export em = new EntityManager "server"
net.listen \god \localhost 9000
net.onOpen = onOpen


function onOpen conn

    console.log \onOpen
    player = net.create PLAYER
    pos = player.get CPosition
    pos.x = 300

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
, 1000 / 60fps

export serverz = true