Taskar.Sections.Actions = {
  click: {
    'input.cancel': function(e, element){
      e.findElement('li').slideUp();
    },
    '.add': function(e, element){
      e.stop();
      
      var newTask = $('new_task');
  
        
      var before = element.getAttribute('data-after'), 
          scroll = false;
      if (before){
        element.up('.task').insert({after: newTask});
      } else {
        $('tasks').insert({bottom: newTask});
        scroll = true;
      }

      Taskar.Sections.resetTaskForm(newTask.down('form'), before);

      if (newTask.visible()){
        newTask.down('textarea').focus();
        return scroll && new Taskar.FX.ScrollTo(newTask);
      }

      newTask.slideDown(function(e){
        e.element.down('textarea').focus();
        scroll && new Taskar.FX.ScrollTo(e.element);
      });
    },
    '.toggle_archived': function(e, element){
      e.stop();
      
      var archive = $('archived_tasks');
      if (archive){
        element.toggleClassName('selected');
        return archive.toggleWithEffect('slide', function(e){
          if (archive.visible()){
            new Taskar.FX.ScrollTo(element);
          }
        });
      }
      
      element.addClassName('loading');
      
      new Ajax.Request(element.getAttribute('data-url'), {
        method:     'get',
        onComplete: function(t){
          element.removeClassName('loading');
          element.addClassName('selected');
          e.findElement('ul').insert({ after: t.responseText });
          $('archived_tasks').hide().slideDown(function(e){ new Taskar.FX.ScrollTo(element); })
        }
      });
    }
  },
  'drag:start': {
    '.tasks_list': function(e, element){
      element.addClassName('dragging');
    }
  },
  'drag:finish': {
    '.tasks_list': function(e, element){
      element.removeClassName('dragging');
    },
    '.task': function(e, element){
      var section = e.memo.originalEvent.findElement('.section');
      if (section && !section.down('.selected')){
        new Ajax.Request(element.getAttribute('data-change-section'), {
          method:     'put',
          parameters: {section_id: section.extractId()}
        });
        element.remove();
      }
    }
  },
  'ajax:post': {
    '#new_task': function(e){
      Taskar.Sections.resetTaskForm(e.findElement('form'));
    }
  },
  'ajax:put': {
    '.archive': function(e){
      var task = e.findElement('.task');
      task.slideUp(function(e){
        var parent, insert, disabled;
        if (task.parentNode.id == 'tasks'){
          parent    = $('archived_tasks');
          insert    = {top: task};
          disabled  = "true";
        } else { 
          parent    = $('tasks');
          insert    = {bottom: task};
          disabled  = null;
        }
        
        task.down('.checkbox').writeAttribute('data-disabled', disabled);
        
        if (!parent){
          task.remove();
        } else {
          parent.insert(insert);
          task.slideDown();
        }
        
        task.fire('task:archive_changed');
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
      var cancel = element.down('.cancel');
      cancel && cancel.request();
    },
    '#new_task': function(e){
      e.findElement('li').slideUp();
    }
  },
  'keyup': {
    'textarea': function(e, element){
      if (e.keyCode == Event.KEY_RETURN && e.shiftKey && element.form){
        e.stop();
        element.fire('ajax:' + $(element.form).request().options.method)
      }
    }
  },
  'task:archive_changed': function(e){
    var archive = $('archived_tasks');
    archive && $('archived_tasks_empty')[archive.getElementsByTagName('li').length == 1 ? 'show' : 'hide']();
  }
};