Taskar.Sections.NewStatus = function(userCard){
  var form = $('new_status');
  
  function hide(){
    form.fade();
  }
  
  userCard.down('img').observe('click', function(){
    form.down('textarea').setValue('').setStyle({backgroundColor: null});
    form.toggleWithEffect('appear', function(e){
      e.element.visible() && e.element.down('textarea').setValue('').focus();
    });
  });
  
  form.observe('submit', Taskar.Sections.validateForm);
  form.observe('key:esc', hide);
  form.observe('ajax:post', hide);
  form.down('input[type=button]').observe('click', hide);
};