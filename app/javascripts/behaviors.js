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

/*
CD3.Behaviors('#nav_sections', function(element){
  new Taskar.Dnd.Sortable(element.parentNode, {
    item:   '.section',
    handle: false,
    moveX:  true,
    moveY:  false
  });
  
  var displayLinks = new Event.Handler(element, 'click', 'a', Event.stop);
  displayLinks.stop = displayLinks.stop.bind(displayLinks);
  
  element.select('.add_section').each(function(add){
    (add.next('.section') || element).store('add_section', add);
  });
  
  element.observe('drag:start', function(){ displayLinks.start() });
  element.observe('drag:finish', function(){
    displayLinks.stop.defer();
    
    element.insert({bottom: element.retrieve('add_section')});
    element.select('.section').each(function(section){
      section.insert({ before: section.retrieve('add_section') });
    });
  });
});
*/