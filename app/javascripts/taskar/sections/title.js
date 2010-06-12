Taskar.Sections.Title = function(section){
  var head = section.down('h1'),
      form = section.down('form');
      
  if (!form){
    return;
  }
  
   head.down('a.edit').observe('click', toggle);
   form.down('input[type=button]').observe('click', toggle);
   form.observe('submit', validate);
   form.observe('keyup', function(e){
     if (e.keyCode == Event.KEY_ESC){
       toggle(e);
     }
   });
   
   function toggle(e){
     if (e && 'stop' in e) e.stop();
     
     head.toggle();
     form.reset();
     form.toggle();
   }
   
   var highlight = new S2.FX.Highlight(section, {after: function(e){ e.element.style.backgroundColor = null; }});
   function validate(e){
     var input = e.findElement('form').down('input[type=text]');
     if (input.getValue().trim().length == 0){
       e.stop();
       Taskar.FX.shake(input, {distance: 2, turns: 2});
       highlight.play(input);
     }
   }
}