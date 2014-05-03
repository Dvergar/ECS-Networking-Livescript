// Generated by LiveScript 1.2.0
(function(){
  'use strict';
  var protoComponents, components, numComponents, componentName, componentType, Entity, EntityManager, em, out$ = typeof exports != 'undefined' && exports || this;
  protoComponents = dcodeIO.ProtoBuf.loadProtoFile('components.proto').build();
  out$.protoComponents = protoComponents;
  components = [];
  numComponents = 0;
  for (componentName in protoComponents) {
    componentType = protoComponents[componentName];
    components.push(componentType);
    componentType.id = numComponents;
    componentType.prototype.id = numComponents++;
    window[componentName + ""] = componentType;
  }
  out$.components = components;
  Entity = (function(){
    Entity.displayName = 'Entity';
    var prototype = Entity.prototype, constructor = Entity;
    Entity.ids = 0;
    prototype.code = 0;
    prototype.components = repeatArray$([undefined], numComponents);
    function Entity(){
      this.id = constructor.ids++;
    }
    prototype.get = function(componentType){
      return this.components[componentType.id];
    };
    return Entity;
  }());
  EntityManager = (function(){
    EntityManager.displayName = 'EntityManager';
    var fps, loops, skipTicks, maxFrameSkip, nextGameTick, netfps, lastNetTick, prototype = EntityManager.prototype, constructor = EntityManager;
    prototype.systems = [];
    prototype.createEntity = function(){
      return new Entity;
    };
    prototype.addComponent = function(entity, component){
      var i$, ref$, len$, system;
      console.log('addComponent');
      entity.components[component.id] = component;
      entity.code = entity.code | 1 << component.id;
      for (i$ = 0, len$ = (ref$ = this.systems).length; i$ < len$; ++i$) {
        system = ref$[i$];
        if ((system.code & entity.code) === system.code) {
          if (system.entities[entity.id] === undefined) {
            system.entities[entity.id] = entity;
            system.onEntityAdded(entity);
          }
        }
      }
      return component;
    };
    prototype.removeComponent = function(entity, component){
      var i$, ref$, len$, system;
      for (i$ = 0, len$ = (ref$ = this.systems).length; i$ < len$; ++i$) {
        system = ref$[i$];
        if ((system.code & entity.code) === system.code) {
          system.onEntityRemoved(entity);
        }
      }
      entity.code = entity.code & ~(1 << component.id);
      return entity.components[component.id] = undefined;
    };
    prototype.getComponent = function(entity, componentType){
      return entity.components[componentType.id];
    };
    prototype.registerSystem = function(system){
      return this.systems.push(system);
    };
    fps = 60;
    loops = 0;
    skipTicks = 1000 / fps;
    maxFrameSkip = 10;
    nextGameTick = new Date().getTime();
    netfps = 20;
    lastNetTick = new Date().getTime();
    prototype.fixedUpdate = function(func){
      var loops, results$ = [];
      if (new Date().getTime() - lastNetTick > 1000 / netfps) {
        net.pump();
        lastNetTick = new Date().getTime();
      }
      loops = 0;
      while (new Date().getTime() > nextGameTick && loops < maxFrameSkip) {
        func();
        nextGameTick += skipTicks;
        results$.push(loops++);
      }
      return results$;
    };
    function EntityManager(){}
    return EntityManager;
  }());
  out$.em = em = new EntityManager;
  function repeatArray$(arr, n){
    for (var r = []; n > 0; (n >>= 1) && (arr = arr.concat(arr)))
      if (n & 1) r.push.apply(r, arr);
    return r;
  }
}).call(this);
