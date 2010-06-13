Taskar.Sections.Tasks = {
  click: {
    '.edit': function(e, element){
      e.stop();
      element.request({
        onLoading: function(){
          element.update("Loading...");
        }
      });
    },
    'a.cancel': function(e, element){
      e.stop();
      element.request({
        onLoading: function(){
          element.update("Loading...");
        }
      });
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
  keyup: {
    '.task': function(e, element){
      if (e.keyCode == Event.KEY_ESC){
        element.down('.cancel').request();
      }
    },
    '#new_task': function(e){
      if (e.keyCode == Event.KEY_ESC){
        e.findElement('li').slideUp();
      }
    }
  },
  submit: function(e){
    e.stop();
    var form = e.findElement('form');
    form.request();
    Taskar.Sections.resetTaskForm(form);
  }
};
