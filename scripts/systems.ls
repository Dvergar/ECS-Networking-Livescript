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
            sprite.anchor.setTo(drawable.anchorx, drawable.anchory);
            # sprite.anchor.setTo(0, 0);
            img = game.cache.getImage(drawable.image_name)
            drawable.width = img.width
            drawable.height = img.height
            console.log \width_ + drawable.width
            # pos.x = pos.x + drawable.anchorx * drawable.width
            # pos.x = pos.y + drawable.anchory * drawable.height

    loop: ->
        for id, entity of @entities
            pos = entity.get(CPosition)
            draw = entity.get(CDrawable)
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

            if input.keyUp then pos.dy -= speed.value
            if input.keyDown then pos.dy += speed.value
            if input.keyLeft then pos.dx -= speed.value
            if input.keyRight then pos.dx += speed.value


class CollisionSystem extends System
    -> @need([CCollidable, CPosition, CDrawable])

    collides_by_axis: (o1pos, o1size, o2pos, o2size) ->
        # console.log o1pos + \_+_ + o1size + \_sup_ + o2pos
        return ((o1pos + o1size) > o2pos &&
                (o2pos + o2size) > o1pos)

    collides: (o1, o2) ->
        # console.log @collides_by_axis(pos.x, draw.width, pos2.x, draw2.width)
        # console.log @collides_by_axis(pos.y, draw.height, pos2.y, draw2.height)
        return (@collides_by_axis(o1.x, o1.width, o2.x, o2.width) &&
                @collides_by_axis(o1.y, o1.height, o2.y, o2.height))

    get_overlap: (o1previous_pos, o1pos, o1size, o2pos, o2size) ->
        if o1previous_pos > o2pos
            return -((o2pos + o2size) - o1pos)
        else
            return (o1pos + o1size) - o2pos

    resolve_objects: (o1, o2) ->
        axis_x = false
        axis_y = false

        pp_collides_x = @collides_by_axis(o1.px, o1.x, o1.width, o2.x, o2.width)
        pp_collides_y = @collides_by_axis(o1.py, o1.y, o1.height, o2.y, o2.height)

        if pp_collides_x
            axis_y = true
        if pp_collides_y
            axis_x = true;

        overlap_x = @get_overlap(o1.px, o1.x, o1.width, o2.x, o2.width)
        overlap_y = @get_overlap(o1.py, o1.y, o1.height, o2.y, o2.height)

        if o1.immovable isnt true
            if Math.abs(overlap_x) < Math.abs(overlap_y)
                o1.x -= overlap_x
                # console.log \overlapx_ + overlap_x
            else o1.y -= overlap_y

    loop: ->
        for id, entity of @entities
            first_list = []
            second_list = []

            pos = entity.get CPosition
            coll = entity.get CCollidable
            draw = entity.get CDrawable
            o1 = {} <<<
                x: pos.x + pos.dx - draw.width * draw.anchorx
                y: pos.y + pos.dy - draw.height * draw.anchory
                px: pos.x - draw.width * draw.anchorx
                py: pos.y - draw.height * draw.anchory
                width: draw.width
                height: draw.height
                immovable: coll.immovable

            for id2, other of @entities
                if other == entity then continue

                otherPos = other.get CPosition
                otherColl = other.get CCollidable
                otherDraw = other.get CDrawable
                o2 = {} <<<
                    x: otherPos.x + otherPos.dx - otherDraw.width * otherDraw.anchorx
                    y: otherPos.y + otherPos.dy - otherDraw.height * otherDraw.anchory
                    width: otherDraw.width
                    height: otherDraw.height

                if !@collides o1, o2 then continue
                if (@collides_by_axis(o1.px, o1.x, o1.width, o2.x, o2.width) ||
                    @collides_by_axis(o1.py, o1.y, o1.height, o2.y, o2.height))
                    # console.log \coll1
                    first_list.push o2
                else
                    # console.log \coll2
                    second_list.push o2

            for obj in first_list
                @resolve_objects o1, obj

            for obj in second_list
                @resolve_objects o1, obj

            # console.log (o1.x)
            # console.log (pos.x + pos.dx)
            # console.log (pos.dx)
            pos.dx = o1.x - pos.x + draw.width * draw.anchorx
            pos.dy = o1.y - pos.y + draw.height * draw.anchory


class MovementSystem extends System
    -> @need([CPosition])
    loop: ->
        for id, entity of @entities
            pos = entity.get(CPosition)
            pos.x += pos.dx
            pos.y += pos.dy
            pos.dx = 0
            pos.dy = 0


class TargetSystem extends System
    -> @need([CPosition, CTargetPosition])

    onEntityAdded: (entity) ->
        pos = entity.get CPosition
        tpos = entity.get CTargetPosition
        tpos.startx = pos.x
        tpos.starty = pos.y
        tpos.percent = tpos.step

    onEntityRemoved: (entity) ->
        console.log \entity_remove_from_TargetSystem

    loop: ->
        for id, entity of @entities
            pos = entity.get CPosition
            tpos = entity.get CTargetPosition
            newx = tpos.startx + (tpos.x - tpos.startx) * tpos.percent
            pos.dx = newx - pos.x
            tpos.percent += tpos.step
            if tpos.percent > 1
                em.removeComponent entity, CTargetPosition


class PhaserFollowMouseSystem extends System
    history: {}

    -> @need([CPosition, CPhaserFollowMouse, CDrawable])

    onEntityAdded: (entity) ->
        pos = entity.get CPosition
        @history[entity.id] = [[pos.x, pos.y]]

    loop: ->
        for id, entity of @entities
            pos = entity.get CPosition
            draw = entity.get CDrawable

            # ROTATION
            dx = game.input.mousePointer.x - @history[id][0][0];
            dy = game.input.mousePointer.y - @history[id][0][1];
            d = Math.sqrt(dx ** 2 + dy ** 2)
            if d > 0
                v = [dx / d, dy / d]
                pos.rotation = Math.atan2(v[1], v[0]) * 180 / Math.PI

            # TRANSLATION
            pos.dx = game.input.mousePointer.x - pos.x;
            pos.dy = game.input.mousePointer.y - pos.y;

            # CACHE FOR UNBUGGY ROTATION
            @history[id]
                if d > 5 then ..push [pos.x, pos.y]
                if ..length > 10 then ..shift!


class ShipCollisionSystem extends System
    -> @need([CCollidable, CShip, CDrawable])

    collides: (a, b) ->
        apos = a.get CPosition
        bpos = b.get CPosition
        adraw = a.get CDrawable
        bdraw = b.get CDrawable

        return !( ((apos.y + adraw.height) < (bpos.y)) ||
                  (apos.y > (bpos.y + bdraw.height))   ||
                  ((apos.x + adraw.width) < bpos.x)    ||
                  (apos.x > (bpos.x + bdraw.width)) )

    loop: ->
        for id, ship of @entities
            shipPos = ship.get CPosition
            shipDrawable = ship.get CDrawable
            shipSprite = Moo.phaserDrawableSystem.drawables[ship.id]
                ..alpha = 1
            
            # SHIP FUCK
            emitter.x = shipSprite.x
            emitter.y = shipSprite.y
            emitter.start true, 500, null, 1

            for id2, collidable of Moo.collisionSystem.entities
                if ship == collidable then continue
                if @collides ship, collidable
                    shipSprite.alpha = 0.5

            #     if ship == collidable then continue

            #     # RAY
            #     dx = dy = 0
            #     startx = shipPos.x
            #     starty = shipPos.y
            #     collision = false
            #     d = Math.sqrt shipPos.dx ** 2 + shipPos.dy ** 2
            #     k = 5 / d
            #     vx = shipPos.dx / d
            #     vy = shipPos.dy / d

            #     for pene from 1 to d by 5
            #         nowx = shipPos.x
            #         nowy = shipPos.y
            #         newx = startx + vx * pene
            #         newy = starty + vy * pene
            #         collision = false
            #         # console.log \wot
            #         console.log (vx * pene)

            #         # X COLLISION
            #         shipPos.x = newx
            #         shipPos.y = nowy
            #         if @collides ship, collidable
            #             newx = nowx
            #             collision = true

            #         # Y COLLISION
            #         shipPos.x = nowx
            #         shipPos.y = newy
            #         if @collides ship, collidable
            #             newy = nowy
            #             collision = true

            #         shipPos.x = newx
            #         shipPos.y = newy

            #         if collision
            #             shipPos.dx = dx - vx * 2
            #             shipPos.dy = dy - vy * 2
            #             break

            #         dx = shipPos.dx + vx * pene
            #         dy = shipPos.dy + vy * pene

            #     if collision
            #         # KNOCKBACK
            #         # shipPos.x -= shipPos.dx / d * 2
            #         # shipPos.y -= shipPos.dy / d * 2
            #         shipSprite.alpha = 0.5

            #     shipPos.x = startx
            #     shipPos.y = starty


export PhaserDrawableSystem
export PhaserInputSystem
export ControllerSystem
export TargetSystem
export PhaserFollowMouseSystem
export CollisionSystem
export ShipCollisionSystem
export MovementSystem