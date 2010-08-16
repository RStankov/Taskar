Taskar.Sections.Ordering = function(element){
  new Taskar.Dnd.Sortable(element, {
    item:       '.section',
    handle:     '.drag',
    moveX:      false,
    moveY:      true
  });
  
  element.on('order:updated', '[data-sortable]', function(e, element){
    new Ajax.Request(element.getAttribute('data-sortable'), {
      method:     'put',
      parameters: e.memo.sortable.serialize('items[]')
    });
  });
};