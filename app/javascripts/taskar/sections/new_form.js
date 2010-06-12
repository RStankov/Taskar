Taskar.Sections.NewForm = function(sectionsBar){
  sectionsBar.on('click',  '.add_section',       show);
  sectionsBar.on('click',  'input[type=button]', hide);
  sectionsBar.on('keyup',  'form',               hideOnEsc);
  sectionsBar.on('submit', 'form',               Taskar.Sections.validateForm);
  
  var appear = new S2.FX.Style(sectionsBar, {
    before: function(e){ e.element.setStyle({ width: '0px', opacity: 0.0 }); },
    after:  function(e){ e.element.down('input[type=text]').focus(); }
  });
  
  function show(e, element){
    e.stop();
    
    var form = $('new_section');
    form.down('form').reset();
    form.down('input[name=before]').setValue(element.getAttribute('data-before'));
    console.log(form.down('input[name=before]').getValue());
      
    if (element.previous() == form && form.visible()){
      return;
    }
    
    form.hide();
  
    element.hide()
    element.show.bind(element).defer();
    element.insert({before: form});
    
    form.show();
    
    appear.play(form, {style: 'opacity:1; width:' + form.getWidth() + 'px'})
  }
  
  function hide(e, element){
    e.findElement('li').hide();
  }
  
  function hideOnEsc(e, element){
    if (e.keyCode == Event.KEY_ESC){
      hide(e);
    }
  }
};