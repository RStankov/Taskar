Taskar.Sections.Comments = {
  'ajax:delete': {
    '.comment': function(e, element){
      element.removeWithEffect('slideUp');
    }
  },
  'key:esc': {
    'form': function(e, element){
      var cancel = element.down('.cancel');
      cancel && cancel.request();
    }
  }
};