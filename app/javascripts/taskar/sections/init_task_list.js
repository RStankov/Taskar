Taskar.Sections.initTaskList = function(element){
  if (!element.down('.task')){
    $('new_task').show().down('textarea').highlight().focus();
  }
  
  new Taskar.Dnd.Sortable(element, {
    list:   '#' + element.id,
    item:   'li.task',
    handle: '.drag'
  });
};