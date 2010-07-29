Taskar.Sections.UserCard = {
  'click': {
    'img': function(){
      $('new_status').toggleWithEffect('appear', function(e){
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
  'submit': Taskar.Sections.validateForm
}