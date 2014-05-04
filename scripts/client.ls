'use strict'

# GAME INITIALIZATION
export game = new Phaser.Game 800px, 600px, Phaser.CANVAS, '',
    update: update
    create: create

var phaserDrawableSystem, positionSystem, phaserInputSystem, controllerSystem

function create
    export em = new EntityManager "client"

    # SYSTEMS
    phaserDrawableSystem := new PhaserDrawableSystem
    positionSystem := new PositionSystem
    phaserInputSystem := new PhaserInputSystem
    controllerSystem := new ControllerSystem

    # ENTITIES
    # player = em.createEntity!
    # em.addComponent player, new CPosition <<<
    #     x: 5
    #     y: 5
    # em.addComponent player, new CDrawable <<<
    #     width: 25
    #     height: 80
    #     color: 0xF5901D
    #     type: CDrawable.Type.RECTANGLE
    # em.addComponent player, new CInput
    # em.addComponent player, new CSpeed

function update
    em.fixedUpdate ->
        phaserInputSystem.loop!
        controllerSystem.loop!
        positionSystem.loop!
        phaserDrawableSystem.loop!


# NETWORK
net.connect \god \localhost 9000
net.onOpen = onOpen

function onOpen id
    console.log \onOpen

    net.sendEvent new INPUT <<<
        key_up: true
        key_down: true
        key_left: true
        key_right: true
        entity_id: 0
