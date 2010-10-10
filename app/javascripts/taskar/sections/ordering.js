Taskar.Sections.Ordering = function(element){
  new Taskar.Dnd.Sortable(element, {
    item:       '.section',
    handle:     '.drag',
    moveX:      false,
    moveY:      true
  });

  element.observe('drag:finish', function(e){
    e.memo.element.setStyle({
      width:  null,
      height: null
    });
  });
};