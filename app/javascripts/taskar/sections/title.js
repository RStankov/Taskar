Taskar.Sections.Title = function(section){
  var head = section.down('h1'),
      form = section.down('form');
  
   head.down('a.edit').observe('click', toggle);
   form.down('input[type=button]').observe('click', toggle);
   form.observe('keyup', function(e){
     if (e.keyCode == Event.KEY_ESC){
       toggle(e);
     }
   });
   
   function toggle(e){
     if (e && 'stop' in e) e.stop();
     
     head.toggle();
     form.toggle();
   }
}