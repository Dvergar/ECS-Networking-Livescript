'use strict'

# GAME INITIALIZATION
export game = new Phaser.Game 800, 600, Phaser.CANVAS, '',
    update: update
    create: create

var drawableSystem, positionSystem, inputSystem, controllerSystem

function create
    # SYSTEMS
    drawableSystem := new DrawableSystem
    positionSystem := new PositionSystem
    inputSystem := new InputSystem
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
        inputSystem.loop!
        controllerSystem.loop!
        positionSystem.loop!
        drawableSystem.loop!


# NETWORK
net.connect \god \localhost 9000
net.onOpen = onOpen

function onOpen id
    console.log \onOpen
