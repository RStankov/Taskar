Taskar.Sections.TaskList = function(element){
  if (!element.down('.task')){
    $('new_task').show().down('textarea').highlight().focus();
  }

  var sectionTitle = $('section_title');
  if (sectionTitle){
    function checkForArchiveButton(){
	    var archive = sectionTitle.down('a.archive');
	    archive && archive[element.down('li.task') ? 'hide' : 'show']();
    }

    sectionTitle.observe('mouseenter', checkForArchiveButton);

    checkForArchiveButton();
  }

  new Taskar.Dnd.Sortable(element, {
    list:   '#' + element.id,
    item:   'li.task',
    handle: '.drag'
  });
};