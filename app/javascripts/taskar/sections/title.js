Taskar.Sections.Title = function(section){
  var head = section.down('h1'),
      form = section.down('form');
      
  if (!form){
    return;
  }
  
  head.down('a.edit').observe('click', show);
  form.down('input[type=button]').observe('click', hide);
  form.observe('submit', Taskar.Sections.validateForm);
  form.observe('key:esc', hide);
  
  function show(e){
    e.stop();
    
    head.morph('opacity: 0.0');
    form.appear(function(){
      form.down('input[type=text]').focus();
    });
  }
  
  function hide(){
    head.morph('opacity: 1.0');
    form.fade();
  }
};