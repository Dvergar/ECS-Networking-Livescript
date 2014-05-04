'user strict'

function player
    entity = em.createEntity!
    em.addComponent entity, new CPosition <<<
        x: 5
        y: 5
    , SYNC
    em.addComponent entity, new CDrawable <<<
        width: 25
        height: 80
        color: 0xF5901D
        type: CDrawable.Type.RECTANGLE

    return entity

export player