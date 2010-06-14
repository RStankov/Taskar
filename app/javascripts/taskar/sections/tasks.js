Taskar.Sections.Tasks = {
  click: {
    '.edit': function(e, element){
      e.stop();
      element.request();
    },
    'a.cancel': function(e, element){
      e.stop();
      element.request();
    },
    'input.cancel': function(e, element){
      e.findElement('li').slideUp();
    },
    '.delete': function(e, element){
      e.stop();
      element.request({
        method: 'delete',
        onCreate: function(){
          element.up('.task').removeWithEffect('slideUp');
        }
      });
    },
    '.checkbox': Taskar.UI.StateCheckboxObserver
  },
  'state:changed': function(e) {
    var checkbox = e.findElement('.checkbox');
    if (checkbox){
      new Ajax.Request(checkbox.getAttribute('data-url'), {
        method:     'put',
        parameters: {state: checkbox.getAttribute('data-state')}
      });
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
    '.task form': function(e, form){
      e.stop();
      form.request();
    },
    '#new_task form': function(e, form){
      e.stop();
      form.request();
      Taskar.Sections.resetTaskForm(form);
    }
  }
};
