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
    }
  }
};