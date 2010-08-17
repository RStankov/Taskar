Taskar.Sections.NewSection = function(container){
  container.on('click',     '.add_section',       show);
  container.on('click',     'input[type=button]', hide);
  container.on('key:esc',   'form',               hide);
  container.on('submit',    'form',               Taskar.Sections.validateForm);
  
  var form    = $('new_section'),
      appear  = new S2.FX.SlideDown(form, function(e){ form.down('input[type=text]').focus(); });
  
  function show(e, element){
    e && e.preventDefault();
    
    form.down('form').reset();
    form.down('input[name*=insert_before]').setValue(element.getAttribute('data-before'));
      
    if (element.previous() == form && form.visible()){
      return;
    }
    
    form.hide();
  
    element.hide()
    element.show.bind(element).defer();
    element.up('li').insert({before: form});
    
    appear.play();
  }
  
  function hide(){
    form.hide();
  }
  
  if (container.select('.section').length == 0){
    show(null, container.down('.add_section'));
  }
};