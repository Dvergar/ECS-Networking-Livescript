// Generated by LiveScript 1.2.0
(function(){
  'use strict';
  var PhaserDrawableSystem, PhaserInputSystem, ControllerSystem, PaddleAutoControllerSystem, TargetSystem, PhaserFollowMouseSystem, out$ = typeof exports != 'undefined' && exports || this;
  PhaserDrawableSystem = (function(superclass){
    var prototype = extend$((import$(PhaserDrawableSystem, superclass).displayName = 'PhaserDrawableSystem', PhaserDrawableSystem), superclass).prototype, constructor = PhaserDrawableSystem;
    prototype.drawables = {};
    function PhaserDrawableSystem(){
      this.need([CDrawable, CPosition]);
    }
    prototype.onEntityAdded = function(entity){
      var drawable, pos, x$, graphics, sprite;
      console.log("DRAWABLE ENTITY ADDED");
      drawable = entity.get(CDrawable);
      pos = entity.get(CPosition);
      if (drawable.type === CDrawable.Type.RECTANGLE) {
        x$ = graphics = game.add.graphics(0, 0);
        x$.beginFill(drawable.color);
        x$.drawRect(0, 0, drawable.width, drawable.height);
        this.drawables[entity.id] = graphics;
      }
      if (drawable.type === CDrawable.Type.IMAGE) {
        sprite = game.add.sprite(0, 0, drawable.image_name);
        return this.drawables[entity.id] = sprite;
      }
    };
    prototype.loop = function(){
      var id, ref$, entity, pos, x$, results$ = [];
      for (id in ref$ = this.entities) {
        entity = ref$[id];
        pos = entity.get(CPosition);
        x$ = this.drawables[id];
        x$.x = pos.x;
        x$.y = pos.y;
        results$.push(x$);
      }
      return results$;
    };
    return PhaserDrawableSystem;
  }(System));
  PhaserInputSystem = (function(superclass){
    var prototype = extend$((import$(PhaserInputSystem, superclass).displayName = 'PhaserInputSystem', PhaserInputSystem), superclass).prototype, constructor = PhaserInputSystem;
    function PhaserInputSystem(){
      this.need([CPosition, CInput]);
      this.keyUp = game.input.keyboard.addKey(Phaser.Keyboard.UP);
      this.keyDown = game.input.keyboard.addKey(Phaser.Keyboard.DOWN);
      this.keyLeft = game.input.keyboard.addKey(Phaser.Keyboard.LEFT);
      this.keyRight = game.input.keyboard.addKey(Phaser.Keyboard.RIGHT);
    }
    prototype.loop = function(){
      var id, ref$, entity, x$, input, results$ = [];
      for (id in ref$ = this.entities) {
        entity = ref$[id];
        x$ = input = entity.get(CInput);
        x$.keyUp = this.keyUp.isDown;
        x$.keyDown = this.keyDown.isDown;
        x$.keyLeft = this.keyLeft.isDown;
        x$.keyRight = this.keyRight.isDown;
        results$.push(x$);
      }
      return results$;
    };
    return PhaserInputSystem;
  }(System));
  ControllerSystem = (function(superclass){
    var prototype = extend$((import$(ControllerSystem, superclass).displayName = 'ControllerSystem', ControllerSystem), superclass).prototype, constructor = ControllerSystem;
    function ControllerSystem(){
      this.need([CPosition, CInput, CSpeed]);
    }
    prototype.loop = function(){
      var id, ref$, entity, input, pos, speed, results$ = [];
      for (id in ref$ = this.entities) {
        entity = ref$[id];
        input = entity.get(CInput);
        pos = entity.get(CPosition);
        speed = entity.get(CSpeed);
        if (input.keyUp) {
          pos.y -= speed.value;
        }
        if (input.keyDown) {
          pos.y += speed.value;
        }
        if (input.keyLeft) {
          pos.x -= speed.value;
        }
        if (input.keyRight) {
          results$.push(pos.x += speed.value);
        }
      }
      return results$;
    };
    return ControllerSystem;
  }(System));
  PaddleAutoControllerSystem = (function(superclass){
    var prototype = extend$((import$(PaddleAutoControllerSystem, superclass).displayName = 'PaddleAutoControllerSystem', PaddleAutoControllerSystem), superclass).prototype, constructor = PaddleAutoControllerSystem;
    function PaddleAutoControllerSystem(){
      this.need([CPosition]);
    }
    prototype.loop = function(){
      var id, ref$, entity, pos, results$ = [];
      for (id in ref$ = this.entities) {
        entity = ref$[id];
        pos = entity.get(CPosition);
        results$.push(pos.x += 1);
      }
      return results$;
    };
    return PaddleAutoControllerSystem;
  }(System));
  TargetSystem = (function(superclass){
    var prototype = extend$((import$(TargetSystem, superclass).displayName = 'TargetSystem', TargetSystem), superclass).prototype, constructor = TargetSystem;
    function TargetSystem(){
      this.need([CPosition, CTargetPosition]);
    }
    prototype.onEntityAdded = function(entity){
      var pos, tpos;
      pos = entity.get(CPosition);
      tpos = entity.get(CTargetPosition);
      tpos.startx = pos.x;
      tpos.starty = pos.y;
      return tpos.percent = tpos.step;
    };
    prototype.loop = function(){
      var id, ref$, entity, pos, tpos, results$ = [];
      for (id in ref$ = this.entities) {
        entity = ref$[id];
        pos = entity.get(CPosition);
        tpos = entity.get(CTargetPosition);
        pos.x = tpos.startx + (tpos.x - tpos.startx) * tpos.percent;
        tpos.percent += tpos.step;
        if (tpos.percent > 1) {
          results$.push(em.removeComponent(entity, CTargetPosition));
        }
      }
      return results$;
    };
    return TargetSystem;
  }(System));
  PhaserFollowMouseSystem = (function(superclass){
    var prototype = extend$((import$(PhaserFollowMouseSystem, superclass).displayName = 'PhaserFollowMouseSystem', PhaserFollowMouseSystem), superclass).prototype, constructor = PhaserFollowMouseSystem;
    function PhaserFollowMouseSystem(){
      this.need([CPosition, CPhaserFollowMouse]);
    }
    prototype.loop = function(){
      var id, ref$, entity, pos, results$ = [];
      for (id in ref$ = this.entities) {
        entity = ref$[id];
        pos = entity.get(CPosition);
        pos.x = game.input.mousePointer.x;
        results$.push(pos.y = game.input.mousePointer.y);
      }
      return results$;
    };
    return PhaserFollowMouseSystem;
  }(System));
  out$.PhaserDrawableSystem = PhaserDrawableSystem;
  out$.PhaserInputSystem = PhaserInputSystem;
  out$.ControllerSystem = ControllerSystem;
  out$.PaddleAutoControllerSystem = PaddleAutoControllerSystem;
  out$.TargetSystem = TargetSystem;
  out$.PhaserFollowMouseSystem = PhaserFollowMouseSystem;
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
