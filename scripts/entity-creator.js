// Generated by LiveScript 1.2.0
(function(){
  'user strict';
  var out$ = typeof exports != 'undefined' && exports || this;
  function PLAYER(){
    var entity, ref$;
    console.log('SIDE_' + CLIENT);
    console.log('SIDE_' + SERVER);
    console.log('PLAYER');
    entity = em.createEntity();
    em.addComponent(entity, (ref$ = new CPosition, ref$.x = 5, ref$.y = 5, ref$));
    if (CLIENT) {
      console.log('CLIENTPLAYER');
      em.addComponent(entity, (ref$ = new CDrawable, ref$.width = 25, ref$.height = 80, ref$.color = 0xF5901D, ref$.type = CDrawable.Type.RECTANGLE, ref$));
      em.addComponent(entity, new CInput);
    }
    return entity;
  }
  net.registerTemplate(PLAYER);
  out$.PLAYER = PLAYER;
}).call(this);
