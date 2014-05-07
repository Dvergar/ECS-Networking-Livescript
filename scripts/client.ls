'use strict'

# GAME INITIALIZATION
export game = new Phaser.Game 640px, 480px, Phaser.CANVAS, '',
    update: update
    create: create
    preload: preload
    render: render

export em = new EntityManager "client"
var wallDrawable
var shipDrawable

function preload
    console.log \preload
    game.load.image 'wall', 'wall.png'
    game.load.image 'ship', 'ship.png'
    game.load.image 'smoke', 'smoke.png'


function create
    # PHASER
    game.stage.backgroundColor = '#070624';
    export emitter = game.add.emitter 0, 0, 100

    emitter.makeParticles('smoke')
    emitter.minRotation = 0
    emitter.maxRotation = 0
    emitter.gravity = 0
    # emitter.start false, 5000, 20
    # emitter.bounce.setTo 0.5, 0.5
    emitter.minParticleAlpha = 0.2
    emitter.maxParticleAlpha = 0.8
    emitter.setXSpeed -20, 20
    emitter.setYSpeed -20, 20

    # SYSTEMS
    em.registerSystem PhaserDrawableSystem
    em.registerSystem PhaserInputSystem
    em.registerSystem ControllerSystem
    em.registerSystem TargetSystem
    em.registerSystem PhaserFollowMouseSystem
    em.registerSystem CollisionSystem
    em.registerSystem ShipCollisionSystem
    em.registerSystem MovementSystem
    em.registerSystem CollisionSystem

    # ENTITIES
    wall = em.createEntity!
    em.addComponent wall, new CPosition <<<
        x: 450px
        y: 100px
        anchorx: 0
        anchory: 0
    em.addComponent wall, new CTargetPosition <<<
        x: 100px
        y: 0px
        step: 0.001
    em.addComponent wall, new CDrawable <<<
        image_name: "wall"
        type: CDrawable.Type.IMAGE
    em.addComponent wall, new CCollidable <<< immovable: true
    wallDrawable := Moo.phaserDrawableSystem.drawables[wall.id]

    ship = em.createEntity!
    em.addComponent ship, new CPosition <<<
        x: 300px
        y: 100px
    em.addComponent ship, new CDrawable <<<
        image_name: "ship"
        anchorx: 0.5
        anchory: 0.5
        type: CDrawable.Type.IMAGE
    em.addComponent ship, new CPhaserFollowMouse
    em.addComponent ship, new CCollidable
    em.addComponent ship, new CShip
    em.addComponent ship, new CSpeed
    em.addComponent ship, new CInput
    shipDrawable := Moo.phaserDrawableSystem.drawables[ship.id]

    console.log Moo.collisionSystem.entities

function collisionHandler wall, ship
    console.log

function update
    em.fixedUpdate ->
        Moo.phaserDrawableSystem.loop!
        Moo.phaserInputSystem.loop!
        Moo.phaserFollowMouseSystem.loop!

        Moo.controllerSystem.loop!
        Moo.targetSystem.loop!
        Moo.shipCollisionSystem.loop!
        Moo.collisionSystem.loop!
        Moo.movementSystem.loop!

function render
    game.debug.bodyInfo(shipDrawable, 16, 24);
    game.debug.body(wallDrawable);
    game.debug.body(shipDrawable);




# NETWORKING
# em.registerEvent(PLAYER, onPlayerCreate)
# function onPlayerCreate event
#     console.log \onPlayerCreate
#     console.log event.entity

# function onInput event
#     console.log \onInput
#     console.log event.key_left
#     console.log event.entity_id

# em.registerEvent(INPUT, onInput)


# # NETWORK
# # net.connect \god \localhost 9000
# # net.onOpen = onOpen

# function onOpen id
#     console.log \onOpen

#     # net.sendEvent new INPUT <<<
#     #     key_up: true
#     #     key_down: true
#     #     key_left: true
#     #     key_right: true
#     #     entity_id: 0
