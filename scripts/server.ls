'use strict'


net.listen \god \localhost 9000
net.onOpen = onOpen


function onOpen conn
    console.log \onOpen
    net.create(player)
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

setInterval  ->
    em.fixedUpdate dummy
, 1000 / 60fps
