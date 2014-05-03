'use strict'

# CLIENT
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


class InputSystem extends System
    ->
        @need([CPosition, CInput])
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


# COMMON
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

export DrawableSystem
export InputSystem
export PositionSystem
export ControllerSystem