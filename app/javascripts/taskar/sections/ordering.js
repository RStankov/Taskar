Taskar.Sections.Ordering = function(sections){
  var element = sections.down('ul'),
      sort    = new Taskar.Dnd.Sortable(element.parentNode, {
                  item:       '.section',
                  handle:     false,
                  moveX:      false,
                  moveY:      true,
                  autostart:  false
                });
  
  var trace = false;
  element.on('mousedown', '.section', function(e){
    e.preventDefault();
    trace = true;
  });

  element.on('mouseup', '.section', function(e){
    trace = false;
  });

  element.on('mousemove', '.section', function(e){
    if (trace){
      sort.startDragging(e);
      trace = false;
    }
  });

  var disable = new Event.Handler(element, 'click', 'a', Event.stop);
  disable.stop = disable.stop.bind(disable);
  
  element.observe('drag:start', function(e){
    disable.start();
    e.findElement().addClassName('dragging');
  });
  
  element.observe('drag:finish', function(e){
    disable.stop.defer();
    e.findElement().removeClassName('dragging');
  });
  
  element.observe('order:updated', function(e){
    new Ajax.Request(element.getAttribute('data-sortable'), {
      method:     'put',
      parameters: e.memo.sortable.serialize('items[]')
    });
  });
};