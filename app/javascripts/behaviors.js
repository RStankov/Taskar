CD3.Behaviors({
  '#nav_sections':    Taskar.Sections.NewForm,
  '#section_title':   Taskar.Sections.Title,
  '#sections_show':   Taskar.Sections.Actions,
  '#comments':        Taskar.Sections.Comments,
  '#live_search':     Taskar.UI.LiveSearch.Form,
  '#tasks':           function(element){
    if (!element.down('.task')){
      $('new_task').show().down('textarea').highlight().focus();
    }
    
    new Taskar.Dnd.Sortable(element, {
      list:   '#' + element.id,
      item:   'li.task',
      handle: '.drag'
    })
  },
  '#scroll_to_top:click': function(e){
    e.stop();
    var id      = this.getAttribute('href').split('#').last(),
        element = $(id);
        
    if (element){
      new Taskar.FX.ScrollTo(element, function(){
        location.hash = id;
      });
    }
  }
});
