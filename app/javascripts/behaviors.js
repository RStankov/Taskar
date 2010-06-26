CD3.Behaviors({
  '#nav_sections':    Taskar.Sections.NewForm,
  '#section_title':   Taskar.Sections.Title,
  '#sections_show':   Taskar.Sections.Actions,
  '#tasks':           Taskar.Sections.initTaskList,
  '#comments':        Taskar.Sections.Comments,
  '#live_search':     Taskar.UI.LiveSearch.Form,
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
