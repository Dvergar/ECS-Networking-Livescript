// Generated by LiveScript 1.2.0
(function(){
  'use strict';
  var components, numComponents, componentName, componentType, Entity, EntityManager, em, out$ = typeof exports != 'undefined' && exports || this;
  components = dcodeIO.ProtoBuf.loadProtoFile('components.proto').build();
  numComponents = 0;
  for (componentName in components) {
    componentType = components[componentName];
    componentType.id = numComponents;
    componentType.prototype.id = numComponents++;
    window[componentName + ""] = componentType;
  }
  Entity = (function(){
    Entity.displayName = 'Entity';
    var prototype = Entity.prototype, constructor = Entity;
    Entity.ids = 0;
    prototype.code = 0;
    prototype.components = repeatArray$([undefined], numComponents);
    function Entity(){
      this.id = constructor.ids++;
    }
    return Entity;
  }());
  EntityManager = (function(){
    EntityManager.displayName = 'EntityManager';
    var prototype = EntityManager.prototype, constructor = EntityManager;
    prototype.systems = [];
    prototype.createEntity = function(){
      return new Entity;
    };
    prototype.addComponent = function(entity, component){
      var i$, ref$, len$, system, results$ = [];
      entity.components[component.id] = component;
      entity.code = entity.code | 1 << component.id;
      for (i$ = 0, len$ = (ref$ = this.systems).length; i$ < len$; ++i$) {
        system = ref$[i$];
        if (system.code & entity.code === system.code) {
          results$.push(system.onEntityAdded(entity));
        }
      }
      return results$;
    };
    prototype.removeComponent = function(entity, component){
      var i$, ref$, len$, system;
      for (i$ = 0, len$ = (ref$ = this.systems).length; i$ < len$; ++i$) {
        system = ref$[i$];
        if (system.code & entity.code === system.code) {
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
