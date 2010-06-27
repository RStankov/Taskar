Taskar.Sections.Ordering = function(element){
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
  
  element.observe('order:updated', function(e){
    new Ajax.Request(element.getAttribute('data-sortable'), {
      method:     'put',
      parameters: e.memo.sortable.serialize('items[]')
    });
  });
};