Taskar.Sections.Tasks = {
  click: {
    'input.cancel': function(e, element){
      e.findElement('li').slideUp();
    },
    '.more': function(e, element){
      var p = element.up('.task').down('p');
      
      if (p.hasClassName('less')){
        p.morph('height:18px', function(){ p.removeClassName('less') });
      } else {
        p.morph('height:' + p.scrollHeight + 'px', function(){ p.addClassName('less') });
      }
      
    }
  },
  'order:updated': function(e){
    new Ajax.Request(this.getAttribute('data-sortable'), {
      method:     'put',
      parameters: e.memo.sortable.serialize('items[]')
    });
  },
  'ajax:put': {
    '.archive': function(e, element){
      e.findElement('.task').removeWithEffect('slideUp');
    } 
  },
  'ajax:delete': {
    '.task': function(e, element){
      Taskar.FX.dropOut(element, function(e){e.element.remove()});
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
