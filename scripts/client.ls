'use strict'

# GAME INITIALIZATION
export game = new Phaser.Game 800px, 600px, Phaser.CANVAS, '',
    update: update
    create: create
    preload: preload

export em = new EntityManager "client"
var phaserDrawableSystem
var phaserInputSystem
var controllerSystem
var targetSystem
var phaserFollowMouseSystem


function preload
    console.log \preload
    game.load.image 'wall', 'wall.png'

function create
    # SYSTEMS
    phaserDrawableSystem := new PhaserDrawableSystem
    phaserInputSystem := new PhaserInputSystem
    controllerSystem := new ControllerSystem
    targetSystem := new TargetSystem
    phaserFollowMouseSystem := new PhaserFollowMouseSystem

    # ENTITIES
    wall = em.createEntity!
    em.addComponent wall, new CPosition <<<
        x: 5px
        y: 5px
    em.addComponent wall, new CTargetPosition <<<
        x: 200px
        y: 300px
        step: 0.01
    em.addComponent wall, new CDrawable <<<
        image_name: "wall"
        type: CDrawable.Type.IMAGE

    ship = em.createEntity!
    em.addComponent ship, new CPosition <<<
        x: 100px
        y: 100px
    em.addComponent ship, new CDrawable <<<
        image_name: "wall"
        type: CDrawable.Type.IMAGE
    em.addComponent ship, new CPhaserFollowMouse

function update
    em.fixedUpdate ->
        phaserInputSystem.loop!
        phaserDrawableSystem.loop!
        phaserFollowMouseSystem.loop!

        controllerSystem.loop!
        targetSystem.loop!


em.registerEvent(PLAYER, onPlayerCreate)
function onPlayerCreate event
    console.log \onPlayerCreate
    console.log event.entity

function onInput event
    console.log \onInput
    console.log event.key_left
    console.log event.entity_id

em.registerEvent(INPUT, onInput)


# NETWORK
# net.connect \god \localhost 9000
# net.onOpen = onOpen

function onOpen id
    console.log \onOpen

    # net.sendEvent new INPUT <<<
    #     key_up: true
    #     key_down: true
    #     key_left: true
    #     key_right: true
    #     entity_id: 0
