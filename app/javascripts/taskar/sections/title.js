Taskar.Sections.Title = {
  'key:esc': {
    'form': function(e, element){
      var cancel = element.down('.cancel');
      cancel && cancel.request();
    }
  }
};