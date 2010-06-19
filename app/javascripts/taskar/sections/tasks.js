Taskar.Sections.Tasks = {
  click: {
    'a.cancel': function(e, element){
      e.stop();
      element.request();
    },
    'input.cancel': function(e, element){
      e.findElement('li').slideUp();
    },
  },
  'ajax:delete': {
    '.task': function(e, element){
      element.removeWithEffect('slideUp');
    }
  },
  'key:esc': {
    '.task': function(e, element){
      element.down('.cancel').request();
    },
    '#new_task': function(e){
      e.findElement('li').slideUp();
    }
  },
  submit: {
    '#new_task form': function(e, form){
      e.stop();
      form.request();
      Taskar.Sections.resetTaskForm(form);
    }
  }
};
