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
  },
  'keyup': {
    'textarea': function(e, element){
      if (e.keyCode == Event.KEY_RETURN && e.shiftKey && element.form){
        e.stop();
        element.fire('ajax:' + $(element.form).request().options.method)
      }
    }
  }
};