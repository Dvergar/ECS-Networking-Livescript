// Generated by LiveScript 1.2.0
(function(){
  'use strict';
  var NetEntityManager, net, out$ = typeof exports != 'undefined' && exports || this;
  NetEntityManager = (function(superclass){
    var entities, CREATE_ENTITY, ADD_COMPONENT, prototype = extend$((import$(NetEntityManager, superclass).displayName = 'NetEntityManager', NetEntityManager), superclass).prototype, constructor = NetEntityManager;
    entities = {};
    prototype.input = new dcodeIO.ByteBuffer;
    prototype.output = new dcodeIO.ByteBuffer;
    CREATE_ENTITY = 0;
    ADD_COMPONENT = 1;
    function NetEntityManager(){
      NetEntityManager.superclass.call(this);
      this.onData = this._onData;
    }
    prototype.createEntity = function(){
      var entity;
      entity = em.createEntity();
      this._sendCreateEntity(entity);
      return entity;
    };
    prototype._sendCreateEntity = function(entity){
      var x$;
      entities[entity.id] = entity;
      x$ = this.output;
      x$.writeInt8(CREATE_ENTITY);
      x$.writeInt16(entity.id);
      return x$;
    };
    prototype.addComponent = function(entity, component){
      em.addComponent(entity, component);
      return this._sendAddComponent(entity, component);
    };
    prototype._sendAddComponent = function(entity, component){
      var x$, compenc;
      x$ = this.output;
      x$.writeInt8(ADD_COMPONENT);
      x$.writeInt16(entity.id);
      x$.writeInt8(component.id);
      compenc = component.encode();
      x$.writeInt16(compenc.length);
      x$.append(compenc);
      return x$;
    };
    prototype.create = function(entityFunction){
      var entity, i$, ref$, len$, component, results$ = [];
      entity = entityFunction();
      this._sendCreateEntity(entity);
      for (i$ = 0, len$ = (ref$ = entity.components).length; i$ < len$; ++i$) {
        component = ref$[i$];
        if (component !== undefined) {
          results$.push(this._sendAddComponent(entity, component));
        }
      }
      return results$;
    };
    prototype.pump = function(){
      var x$, ab, y$;
      x$ = this.output;
      if (x$.offset > 0) {
        ab = this.send(
        x$.toArrayBuffer());
        x$.reset();
      }
      y$ = this.input;
      if (y$.offset > 0) {
        y$.flip();
        this.readMessage();
        y$.reset();
      }
      return y$;
    };
    prototype.readMessage = function(){
      var x$, msgtype, netid, entity, componentType, msglength, mark, component;
      console.log('readMessage');
      x$ = this.input;
      while (x$.remaining() > 0) {
        msgtype = x$.readInt8();
        switch (msgtype) {
        case CREATE_ENTITY:
          netid = x$.readInt16();
          entity = em.createEntity();
          entities[netid] = entity;
          break;
        case ADD_COMPONENT:
          netid = x$.readInt16();
          componentType = x$.readInt8();
          msglength = x$.readInt16();
          mark = x$.offset;
          component = components[componentType].decode(x$);
          em.addComponent(entities[netid], component);
          x$.offset = mark + msglength;
        }
      }
      x$.reset();
      return x$;
    };
    prototype._onData = function(data){
      return this.input.append(
      dcodeIO.ByteBuffer.wrap(
      data));
    };
    return NetEntityManager;
  }(Net));
  out$.net = net = new NetEntityManager;
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
