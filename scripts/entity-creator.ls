'user strict'


function PLAYER
    console.log \SIDE_ + CLIENT
    console.log \SIDE_ + SERVER

    console.log \PLAYER
    entity = em.createEntity!
    em.addComponent entity, new CPosition <<<
        x: 5
        y: 5
    # , SYNC

    if CLIENT
        console.log \CLIENTPLAYER
        em.addComponent entity, new CDrawable <<<
            width: 25px
            height: 80px
            color: 0xF5901D
            type: CDrawable.Type.RECTANGLE

        em.addComponent entity, new CInput

    return entity
net.registerTemplate(PLAYER)

export PLAYER