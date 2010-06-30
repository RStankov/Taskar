Taskar.Sections.initTaskList = function(element){
  if (!element.down('.task')){
    $('new_task').show().down('textarea').highlight().focus();
  }
  
  if (element){
    $('section_title').observe('mouseenter', checkForArchiveButton);
    
    function checkForArchiveButton(){
      $('section_title').down('a.archive')[element.down('li.task') ? 'hide' : 'show']();
    }
    
    checkForArchiveButton();
  }
  
  new Taskar.Dnd.Sortable(element, {
    list:   '#' + element.id,
    item:   'li.task',
    handle: '.drag'
  });
};