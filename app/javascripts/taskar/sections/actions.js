Taskar.Sections.Actions = {
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
    },
    '.add': function(){
      var newTask = $('new_task');

      Taskar.Sections.resetTaskForm(newTask.down('form'));

      if (newTask.visible() && !newTask.next()){
        return newTask.down('textarea').focus();
      }

      newTask.slideDown(function(e){
        e.element.down('textarea').focus();
        new Taskar.FX.ScrollTo(e.element);
      });
    },
    '.toggle_archived': function(e, element){
      var archive = $('archived_tasks');
      if (archive){
        element.toggleClassName('selected');
        return archive.toggle();
      }
      
      element.addClassName('loading');
      
      new Ajax.Request(element.getAttribute('data-url'), {
        method:     'get',
        onComplete: function(t){
          element.removeClassName('loading');
          element.addClassName('selected');
          e.findElement('ul').insert({ after: t.responseText });
        }
      });
    }
  },
  'order:updated': function(e){
    new Ajax.Request(e.findElement('#tasks').getAttribute('data-sortable'), {
      method:     'put',
      parameters: e.memo.sortable.serialize('items[]')
    });
  },
  'ajax:put': {
    '.archive': function(e){
      var task = e.findElement('.task');
      task.slideUp(function(e){
        var parent, insert;
        if (task.parentNode.id == 'tasks'){
          parent = $('archived_tasks');
          insert = {top: task};
        } else { 
          parent = $('tasks');
          insert = {bottom: task};
        }
        
        if (!parent){
          task.remove();
        } else {
          parent.insert(insert);
          task.slideDown();
        }
      });
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