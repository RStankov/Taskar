Taskar.Dnd = {
  DraggingObserver: Class.create({
      initialize: function(element){
          this.element = element;
      },
      onEnd: function(){
          Sortable.destroy(this.element.identify());
          Draggables.removeObserver(this.element);
      }
  }),
  startSorting: function(e, element){
    var item    = element.up('li'),
        list    = item.up('ul'),
        options = {
          tag: list.getAttribute('data-sort') || 'li'
        };
        
    if (list.getAttribute('data-sortable')){
      options.onUpdate = function(){
        new Ajax.Request(list.getAttribute('data-sortable'), {
					method: 	'put',
					parameters: Sortable.serialize(list.identify(), {name: 'items'})
				});
      }
    }
    
    Sortable.create(list, options);

    var drag = Sortable.sortables[ list.identify() ].draggables.find(function(drag){ return drag.element == item; });
    if (drag){
      drag.initDrag(e);
      Draggables.addObserver(new Taskar.Dnd.DraggingObserver(list));
    }
  }
};