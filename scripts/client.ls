'use strict'


class A
    a :5

    ->  @blabla = @hello

    hello: (word) ->
        console.log word

a = new A
a.blabla \john


# GAME INITIALIZATION
game = new Phaser.Game(800, 600, Phaser.CANVAS, '',
    update: update
    create: create
)


# SYSTEMS
class DrawableSystem extends System
    drawables: {}
    -> @need([CDrawable, CPosition])

    onEntityAdded: (entity) ->
        console.log "DRAWABLE ENTITY ADDED"
        drawable = entity.get(CDrawable)
        pos = entity.get(CPosition)

        if(drawable.type is CDrawable.Type.RECTANGLE)
            graphics = game.add.graphics 0 0
                ..beginFill(drawable.color)
                ..drawRect(0, 0, drawable.width, drawable.height)
            @drawables[entity.id] = graphics

    loop: ->
        for id, entity of @entities
            pos = entity.get(CPosition)
            @drawables[id]
                ..x = pos.x
                ..y = pos.y


class PositionSystem extends System
    -> @need([CPosition])


class ControllerSystem extends System
    -> @need([CPosition, CInput, CSpeed])

    loop: ->
        for id, entity of @entities
            input = entity.get(CInput)
            pos = entity.get(CPosition)
            speed = entity.get(CSpeed)

            if input.keyUp then pos.y -= speed.value
            if input.keyDown then pos.y += speed.value
            if input.keyLeft then pos.x -= speed.value
            if input.keyRight then pos.x += speed.value


class InputSystem extends System
    ->
        @need([CPosition])
        @keyUp := game.input.keyboard.add-key Phaser.Keyboard.UP
        @keyDown := game.input.keyboard.add-key Phaser.Keyboard.DOWN
        @keyLeft := game.input.keyboard.add-key Phaser.Keyboard.LEFT
        @keyRight := game.input.keyboard.add-key Phaser.Keyboard.RIGHT

    loop: ->
        for id, entity of @entities
            input = entity.get(CInput)
                ..keyUp = @keyUp.is-down
                ..keyDown = @keyDown.is-down
                ..keyLeft = @keyLeft.is-down
                ..keyRight = @keyRight.is-down


var drawableSystem, positionSystem, inputSystem, controllerSystem

function create
    # SYSTEMS
    drawableSystem := new DrawableSystem
    positionSystem := new PositionSystem
    inputSystem := new InputSystem
    controllerSystem := new ControllerSystem

    # ENTITIES
    player = em.createEntity!
    position = new CPosition
        ..x = 5
        ..y = 5
        ..z = 5
        ..a = 5
    drawable = new CDrawable
        ..width = 25
        ..height = 80
        ..color = 0xF5901D
        ..type = CDrawable.Type.RECTANGLE
    em.addComponent player, position
    em.addComponent player, drawable
    em.addComponent player, new CInput
    em.addComponent player, new CSpeed

    console.log position.encode()

function update
    inputSystem.loop!
    controllerSystem.loop!
    positionSystem.loop!
    drawableSystem.loop!


# Peer.js
# peer = new Peer null, {host: \localhost, port: 9000}
# conn = peer.connect \god
# <-! conn .on \open
# conn.send "hello"
# conn .on \data (data) !->
#     console.log data


# conn = peer.connect \god
# conn .on \open (id) ->
#     conn.send "hello"

#     conn .on \data (data) !->
#         console.log data


net.connect \god \localhost, 9000
net.onOpen = onOpen


function onOpen id
    console.log \onOpen
    net.send \hello
