Taskar.Sections.Comments = {
  'ajax:delete': {
    '.comment': function(e, element){
      element.removeWithEffect('slideUp');
    }
  },
  'key:esc': {
    'form': Taskar.Sections.cancelAction
  }
};