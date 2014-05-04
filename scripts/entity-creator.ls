'user strict'


function PLAYER
    console.log \SIDE_ + CLIENT
    console.log \SIDE_ + SERVER

    console.log \PLAYER
    entity = em.createEntity!
    em.addComponent entity, new CPosition <<<
        x: 5
        y: 5
    , SYNC

    if CLIENT
        console.log \CLIENTPLAYER
        em.addComponent entity, new CDrawable <<<
            width: 25
            height: 80
            color: 0xF5901D
            type: CDrawable.Type.RECTANGLE

    return entity
net.registerTemplate(PLAYER)

export PLAYER