Taskar.Sections.TaskList = function(element){
  if (!element.down('.task')){
    $('new_task').show().down('textarea').highlight().focus();
  }
  
  
  if (element){
    function checkForArchiveButton(){
	    var archive = $('section_title').down('a.archive');
	    archive && archive[element.down('li.task') ? 'hide' : 'show']();
    }
    
    $('section_title').observe('mouseenter', checkForArchiveButton);
    
    checkForArchiveButton();
  }
  
  new Taskar.Dnd.Sortable(element, {
    list:   '#' + element.id,
    item:   'li.task',
    handle: '.drag'
  });
};