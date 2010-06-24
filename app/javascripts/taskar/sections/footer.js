Taskar.Sections.Footer = {
  click: {
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
  }
};