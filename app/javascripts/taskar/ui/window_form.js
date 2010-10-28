Taskar.UI.WindowForm = function(form){
  form = $(form);

  var hideFormHandler = new Event.Handler(document, "click", null, function(e){
    e.findElement().descendantOf(form) || hide();
  });

  function hide(){
    form.fade();
    hideFormHandler.stop();
  }

  function show(){
    form.down('textarea').setValue('').focus();
    hideFormHandler.start();
  }

  form.observe('submit', Taskar.Sections.validateForm);
  form.observe('key:esc', hide);
  form.observe('ajax:post', hide);
  form.down('input[type=button]').observe('click', hide);

  return function(){
    form.down('textarea').setValue('').setStyle({backgroundColor: null});
    form.appear(show);
  };
};