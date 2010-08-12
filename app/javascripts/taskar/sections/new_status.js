Taskar.Sections.NewStatus = {
  'click': {
    'img': function(){
      var form = $('new_status');
      form.down('textarea').setValue('').setStyle({backgroundColor: null});
      form.toggleWithEffect('appear', function(e){
        e.element.visible() && e.element.down('textarea').setValue('').focus();
      });
    },
    'input[type=button]': function(){
      $('new_status').fade();
    }
  },
  'key:esc': function(){
    $('new_status').fade();
  },
  'keyup': {
    'textarea': function(e, element){
      if (e.keyCode == Event.KEY_RETURN && e.shiftKey && element.form){
        e.stop();
        element.fire('ajax:' + $(element.form).request().options.method)
      }
    }
  },
  'submit': Taskar.Sections.validateForm,
  'ajax:post': function(){
    $('new_status').fade();
  }
}