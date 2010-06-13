CD3.Behaviors({
  '#nav_sections':  Taskar.Sections.NewForm,
  '#section_title': Taskar.Sections.Title,
  '#tasks:click': {
    '.cancel': function(e, element){
      e.findElement('li').slideUp();
    },
    '.delete': function(e, element){
      e.stop();
      element.request({
        method: 'delete',
        onComplete: function(){
          e.findElement('.task').slideUp(function(e){
            e.element.remove();
          });
        }
      })
    }
  },
  '#add_task_button:click': function(){
    var newTask = $('new_task');
        
    newTask.down('form').reset();
    
    if (newTask.visible() && !newTask.next()){
      return newTask.down('textarea').focus();
    }
    
    newTask.slideDown(function(e){
      e.element.down('textarea').focus();
      new Taskar.FX.ScrollTo(e.element);
    });
  }
})