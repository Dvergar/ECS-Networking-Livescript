'use strict'

# Entity System
player = em.createEntity!
position = new CPosition
    ..x = 5
    ..y = 5
drawable = new CDrawable
    ..imageName = "lel.png"


class DrawableSystem extends System
    drawables: {}
    ->
        @need([CDrawable, CPosition])

    onEntityAdded: (entity) ->
        console.log "YEP"


class PositionSystem extends System
    ->
        @need([CPosition])

    onEntityAdded: (entity) ->
        console.log "entity #entity has been added"


new DrawableSystem
new PositionSystem
em.addComponent player, position
em.addComponent player, drawable


# Phaser.IO
game = new Phaser.Game(800, 600, Phaser.CANVAS, '',
  create: create
  render: render
)

var paddle1

function create
  paddle1 := new Phaser.Rectangle 0 0 25 80

function render
  game.debug.geom paddle1, \#0fffff

# Peer.js
# peer = new Peer {host: \localhost, port: 9000}
# conn = peer.connect \god
# <- conn .on \open
# conn.send position.toArrayBuffer!
