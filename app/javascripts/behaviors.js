CD3.Behaviors({
  '#nav_sections':  Taskar.Sections.NewForm,
  '#section_title': Taskar.Sections.Title,
  '#tasks':         Taskar.Sections.Tasks,
  '#comments':      Taskar.Sections.Comments,
  '#scroll_to_top:click': function(e){
    e.stop();
    var id      = this.getAttribute('href').split('#').last(),
        element = $(id);
        
    if (element){
      new Taskar.FX.ScrollTo(element, function(){
        location.hash = id;
      });
    }
  },
  '#add_task_button:click': function(){
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
});

CD3.Behaviors('#tasks', function(element){
  new Taskar.Dnd.Sortable(element, {
    list:   '#' + element.id,
    item:   'li.task',
    handle: '.drag'
  })
});