Taskar.NewSectionForm = function(sectionsBar){
  function show(e, element){
    e.stop();
    
    var form = $('new_section');
    form.down('form').reset();
  
    element.hide()
    element.show.bind(element).defer();
    
    element.insert({before: form.show()});
    
    form.show();
    form.down('input[type=text]').focus();
  }
  
  function hide(e, element){
    e.findElement('li').hide();
  }
  
  function hideOnEsc(e, element){
    if (e.keyCode == Event.KEY_ESC){
      hide(e);
    }
  }
  
  var highlight = new S2.FX.Highlight(sectionsBar, {after: function(e){ e.element.style.backgroundColor = null; }});
  function validate(e, form){
    var input = form.down('input[type=text]');
    if (input.getValue().trim().length == 0){
      e.stop();
      Taskar.FX.shake(input, {distance: 2, turns: 2});
      highlight.play(input);
    }
  }
  
  sectionsBar.on('click',  '.add_section',       show);
  sectionsBar.on('click',  'input[type=button]', hide);
  sectionsBar.on('keyup',  'form',               hideOnEsc);
  sectionsBar.on('submit', 'form',               validate);
};