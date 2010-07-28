Taskar.Sections.UserCard = {
  'click': {
    'img': function(){
      $('new_status').toggleWithEffect('appear');
    },
    'input[type=button]': function(){
      $('new_status').fade();
    }
  },
  'key:esc': function(){
    $('new_status').fade();
  }
}