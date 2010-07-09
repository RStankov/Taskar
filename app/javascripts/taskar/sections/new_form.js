Taskar.Sections.NewForm = function(container){
  container.on('click',     '.add_section',       show);
  container.on('click',     'input[type=button]', hide);
  container.on('key:esc',   'form',               hide);
  container.on('submit',    'form',               Taskar.Sections.validateForm);
  
  var form   = $('new_section'),
      width  = form.getWidth(),
      appear = new S2.FX.Style(form, {
        before: function(e){ form.setStyle({ width: '0px', opacity: 0.0 }); },
        after:  function(e){ form.down('input[type=text]').focus(); }
      });
  
  function show(e, element){
    e.stop();
    
    form.down('form').reset();
    form.down('input[name*=insert_before]').setValue(element.getAttribute('data-before'));
      
    if (element.previous() == form && form.visible()){
      return;
    }
    
    form.hide();
  
    element.hide()
    element.show.bind(element).defer();
    element.insert({before: form});
    
    form.show();
    
    appear.play(null, {style: 'opacity:1; width:' + form.getWidth() + 'px'});
  }
  
  function hide(){
    form.hide();
  }
  
  if (container.select('.section').length == 0){
    form.show().down('input[type=text]').highlight().focus();
  }
};