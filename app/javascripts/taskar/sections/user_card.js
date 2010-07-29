Taskar.Sections.UserCard = {
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
  'submit': Taskar.Sections.validateForm,
  'ajax:post': function(){
    $('new_status').fade();
  }
}