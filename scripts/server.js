// Generated by LiveScript 1.2.0
(function(){
  'use strict';
  net.listen('god', 'localhost', 9000);
  net.onOpen = onOpen;
  function onOpen(conn){
    var player, ref$;
    console.log('onOpen');
    player = net.createEntity();
    net.addComponent(player, (ref$ = new CPosition, ref$.x = 5, ref$.y = 5, ref$));
    return net.addComponent(player, (ref$ = new CDrawable, ref$.width = 25, ref$.height = 80, ref$.color = 0xF5901D, ref$.type = CDrawable.Type.RECTANGLE, ref$));
  }
  function dummy(){
    return console.log;
  }
  setInterval(function(){
    return em.fixedUpdate(dummy);
  }, 1000 / 60);
}).call(this);
