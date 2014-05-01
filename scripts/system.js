// Generated by LiveScript 1.2.0
(function(){
  'use strict';
  var System, out$ = typeof exports != 'undefined' && exports || this;
  System = (function(){
    System.displayName = 'System';
    var prototype = System.prototype, constructor = System;
    prototype.entities = {};
    prototype.need = function(componentTypeList){
      var i$, len$, componentType, results$ = [];
      for (i$ = 0, len$ = componentTypeList.length; i$ < len$; ++i$) {
        componentType = componentTypeList[i$];
        results$.push(em.registerSystem(this, componentTypeList));
      }
      return results$;
    };
    prototype.onEntityAdded = function(entity){
      return console.log("An entity has been added but nothing has been catched");
    };
    prototype.onComponentAdded = function(entity, component){
      return console.log("A component " + component + " added but nothing has been catched");
    };
    prototype._onComponentAdded = function(entity, component){
      this.onComponentAdded(entity, component);
      if (this.entities[entity + ""] === undefined) {
        this.entities[entity + ""] = [];
        this.onEntityAdded(entity);
      }
      return this.entities[entity].push(component);
    };
    function System(){}
    return System;
  }());
  out$.System = System;
}).call(this);
