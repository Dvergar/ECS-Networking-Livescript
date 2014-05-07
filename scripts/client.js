// Generated by LiveScript 1.2.0
(function(){
  'use strict';
  var game, em, wallDrawable, shipDrawable, out$ = typeof exports != 'undefined' && exports || this;
  out$.game = game = new Phaser.Game(640, 480, Phaser.CANVAS, '', {
    update: update,
    create: create,
    preload: preload,
    render: render
  });
  out$.em = em = new EntityManager("client");
  function preload(){
    console.log('preload');
    game.load.image('wall', 'wall.png');
    game.load.image('ship', 'ship.png');
    return game.load.image('smoke', 'smoke.png');
  }
  function create(){
    var emitter, wall, ref$, ship;
    game.stage.backgroundColor = '#070624';
    out$.emitter = emitter = game.add.emitter(0, 0, 100);
    emitter.makeParticles('smoke');
    emitter.minRotation = 0;
    emitter.maxRotation = 0;
    emitter.gravity = 0;
    emitter.minParticleAlpha = 0.2;
    emitter.maxParticleAlpha = 0.8;
    emitter.setXSpeed(-20, 20);
    emitter.setYSpeed(-20, 20);
    em.registerSystem(PhaserDrawableSystem);
    em.registerSystem(PhaserInputSystem);
    em.registerSystem(ControllerSystem);
    em.registerSystem(TargetSystem);
    em.registerSystem(PhaserFollowMouseSystem);
    em.registerSystem(CollisionSystem);
    em.registerSystem(ShipCollisionSystem);
    em.registerSystem(MovementSystem);
    em.registerSystem(CollisionSystem);
    wall = em.createEntity();
    em.addComponent(wall, (ref$ = new CPosition, ref$.x = 450, ref$.y = 100, ref$.anchorx = 0, ref$.anchory = 0, ref$));
    em.addComponent(wall, (ref$ = new CTargetPosition, ref$.x = 100, ref$.y = 0, ref$.step = 0.001, ref$));
    em.addComponent(wall, (ref$ = new CDrawable, ref$.image_name = "wall", ref$.type = CDrawable.Type.IMAGE, ref$));
    em.addComponent(wall, (ref$ = new CCollidable, ref$.immovable = true, ref$));
    wallDrawable = Moo.phaserDrawableSystem.drawables[wall.id];
    ship = em.createEntity();
    em.addComponent(ship, (ref$ = new CPosition, ref$.x = 300, ref$.y = 100, ref$));
    em.addComponent(ship, (ref$ = new CDrawable, ref$.image_name = "ship", ref$.anchorx = 0.5, ref$.anchory = 0.5, ref$.type = CDrawable.Type.IMAGE, ref$));
    em.addComponent(ship, new CPhaserFollowMouse);
    em.addComponent(ship, new CCollidable);
    em.addComponent(ship, new CShip);
    em.addComponent(ship, new CSpeed);
    em.addComponent(ship, new CInput);
    shipDrawable = Moo.phaserDrawableSystem.drawables[ship.id];
    return console.log(Moo.collisionSystem.entities);
  }
  function collisionHandler(wall, ship){
    return console.log;
  }
  function update(){
    return em.fixedUpdate(function(){
      Moo.phaserDrawableSystem.loop();
      Moo.phaserInputSystem.loop();
      Moo.phaserFollowMouseSystem.loop();
      Moo.controllerSystem.loop();
      Moo.targetSystem.loop();
      Moo.shipCollisionSystem.loop();
      Moo.collisionSystem.loop();
      return Moo.movementSystem.loop();
    });
  }
  function render(){
    game.debug.bodyInfo(shipDrawable, 16, 24);
    game.debug.body(wallDrawable);
    return game.debug.body(shipDrawable);
  }
}).call(this);
