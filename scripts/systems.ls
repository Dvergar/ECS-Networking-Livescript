'use strict'

# CLIENT
class PhaserDrawableSystem extends System
    drawables: {}
    -> @need([CDrawable, CPosition])

    onEntityAdded: (entity) ->
        console.log "DRAWABLE ENTITY ADDED"
        drawable = entity.get(CDrawable)
        pos = entity.get(CPosition)

        if(drawable.type is CDrawable.Type.RECTANGLE)
            graphics = game.add.graphics 0px 0px
                ..beginFill(drawable.color)
                ..drawRect 0px, 0px, drawable.width, drawable.height
            @drawables[entity.id] = graphics

        if(drawable.type is CDrawable.Type.IMAGE)
            sprite = game.add.sprite 0, 0, drawable.image_name
            @drawables[entity.id] = sprite
            sprite.anchor.setTo(0.5, 0.5);


    loop: ->
        for id, entity of @entities
            pos = entity.get(CPosition)
            @drawables[id]
                ..x = pos.x
                ..y = pos.y
                ..angle = pos.rotation


class PhaserInputSystem extends System
    ->
        @need([CPosition, CInput])
        @keyUp := game.input.keyboard.add-key Phaser.Keyboard.UP
        @keyDown := game.input.keyboard.add-key Phaser.Keyboard.DOWN
        @keyLeft := game.input.keyboard.add-key Phaser.Keyboard.LEFT
        @keyRight := game.input.keyboard.add-key Phaser.Keyboard.RIGHT

    loop: ->
        for id, entity of @entities
            input = entity.get CInput
                ..keyUp = @keyUp.is-down
                ..keyDown = @keyDown.is-down
                ..keyLeft = @keyLeft.is-down
                ..keyRight = @keyRight.is-down

            # net.sendEvent new INPUT <<<
            #     keyUp: @keyUp.is-down
            #     keyDown: @keyDown.is-down
            #     keyLeft: @keyLeft.is-down
            #     keyRight: @keyRight.is-down


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


class PaddleAutoControllerSystem extends System
    -> @need([CPosition])

    loop: ->
        for id, entity of @entities
            pos = entity.get CPosition
            pos.x += 1px


class TargetSystem extends System
    -> @need([CPosition, CTargetPosition])

    onEntityAdded: (entity) ->
        pos = entity.get CPosition
        tpos = entity.get CTargetPosition
        tpos.startx = pos.x
        tpos.starty = pos.y
        tpos.percent = tpos.step

    loop: ->
        for id, entity of @entities
            pos = entity.get CPosition
            tpos = entity.get CTargetPosition
            pos.x = tpos.startx + (tpos.x - tpos.startx) * tpos.percent
            tpos.percent += tpos.step
            if tpos.percent > 1
                em.removeComponent entity, CTargetPosition


class PhaserFollowMouseSystem extends System
    history: {}

    -> @need([CPosition, CPhaserFollowMouse])

    onEntityAdded: (entity) ->
        pos = entity.get CPosition
        @history[entity.id] = [[pos.x, pos.y]]

    loop: ->
        for id, entity of @entities
            pos = entity.get CPosition

            # ROTATION
            dx = game.input.mousePointer.x - @history[id][0][0];
            dy = game.input.mousePointer.y - @history[id][0][1];
            d = Math.sqrt(dx ** 2 + dy ** 2)
            if d > 0
                v = [dx / d, dy / d]
                pos.rotation = Math.atan2(v[1], v[0]) * 180 / Math.PI

            # TRANSLATION
            pos.x = game.input.mousePointer.x;
            pos.y = game.input.mousePointer.y;

            # CACHE FOR PROPER ROTATION
            @history[id]
                if d > 5 then ..push [pos.x, pos.y]
                if ..length > 10 then ..shift!


export PhaserDrawableSystem
export PhaserInputSystem
export ControllerSystem
export PaddleAutoControllerSystem
export TargetSystem
export PhaserFollowMouseSystem