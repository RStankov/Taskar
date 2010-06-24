Taskar.Sections.Comments = {
  'ajax:delete': {
    '.comment': function(e, element){
      element.removeWithEffect('slideUp');
    }
  },
  'key:esc': {
    'form': function(e, element){
      element.down('.cancel').request();
    }
  }
};