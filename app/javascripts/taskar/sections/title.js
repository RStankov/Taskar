Taskar.Sections.Title = function(section){
  var head = section.down('h1'),
      form = section.down('form');
      
  if (!form){
    return;
  }
  
  head.down('a.edit').observe('click', show);
  form.down('input[type=button]').observe('click', hide);
  form.observe('submit', validate);
  form.observe('keyup', function(e){
    if (e.keyCode == Event.KEY_ESC){
      hide();
    }
  });
  
  function hide(){
    head.morph('opacity: 1.0');
    form.fade();
  }
  
  function show(e){
    e.stop();
    
    head.morph('opacity: 0.0');
    form.appear(function(){
      form.down('input[type=text]').focus();
    });
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