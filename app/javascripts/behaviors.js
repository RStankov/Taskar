CD3.Behaviors({
  '#nav_sections':    Taskar.Sections.NewForm,
  '#section_title':   Taskar.Sections.Title,
  '#tasks':           Taskar.Sections.Tasks,
  '#section_footer':  Taskar.Sections.Footer,
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

CD3.Behaviors('#tasks', function(element){
  new Taskar.Dnd.Sortable(element, {
    list:   '#' + element.id,
    item:   'li.task',
    handle: '.drag'
  })
});