Taskar.Sections.Tasks = {
  click: {
    'input.cancel': function(e, element){
      e.findElement('li').slideUp();
    },
  },
  'order:updated': function(e){
    new Ajax.Request(this.getAttribute('data-sortable'), {
      method:     'put',
      parameters: e.memo.sortable.serialize('items[]')
    });
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
