/*

options (draggable):
	- filter
	- moveX
	- moveY

options (sortable)
	view CD3.Dnd.Sortable.DEFAULT_OPTIONS

events (dragable):
  drag:before
	drag:start
	drag:move
	drag:finish

events (sortable)
	order:changed
	order:updated

*/
Taskar.Dnd = (function() {
  var element, original, options, offset, style;

  function fireEvent(eventName, e) {
    return element.fire('drag:' + eventName, {
      element:        element,
      originalEvent:  e,
      x:		          e.pointerX(),
      y:		          e.pointerY()
    });
  }

  function start(drag, e, givenOptions) {
    e.stop();

    if (element) {
      end(e);
    }

    element		= $(drag);
    style     = element.style;
    options		= givenOptions || {};
    original	= {
      position: style.position,
      zIndex:   style.zIndex,
      top:      style.top,
      left:     style.left
    };

    var cumulativeOffset = element.cumulativeOffset();

    offset = {
      x: e.pointerX() - cumulativeOffset[0],
      y: e.pointerY() - cumulativeOffset[1]
    };

    if (fireEvent('before', e).stopped) {
      return false;
    }

    element.absolutize();
    element.style.zIndex = "9999";

    fireEvent('start', e);

    document.observe('mousemove', move);
    document.observe('mouseup', end);
  }

  function move(e) {
    e.stop();

    if (!element) return;

    var cumulativeOffset = element.cumulativeOffset();
    var position = {
      x: e.pointerX() - cumulativeOffset[0] + (parseInt(element.getStyle('left'), 10) || 0) - offset.x,
      y: e.pointerY() - cumulativeOffset[1] + (parseInt(element.getStyle('top'),  10)  || 0) - offset.y
    };

    if (options.filter)         position   = options.filter(position);
    if (options.moveX != false) element.style.left = position.x + 'px';
    if (options.moveY != false) element.style.top  = position.y + 'px';

    if (fireEvent('move', e).stopped) {
      end(e);
    }
  }

  function end(e) {
    e.stop();
    if (!element) {
      return;
    }

    fireEvent('finish', e);

    element.setStyle(original);

    element = original = options = offset = style = null;

    document.stopObserving('mousemove', move);
    document.stopObserving('mouseup', end);
  }

  return {
    drag: start,
    startDragging: function(e, element) {
      start(element || e.findElement(), e);
    }
  };
})();

Taskar.Dnd.Sortable = Class.create({
  initialize: function(container, options) {
    this.container  = container = $(container);
    this.options    = options   = Object.extend(Object.clone(this.constructor.DEFAULT_OPTIONS), options || {});

    if (options.autostart) {
      container.on('mousedown', options.handle || options.item, this.startDragging.bind(this));
    }

    container.observe('drag:start', 	this.onDragStart.bind(this));
    container.observe('drag:move',		this.onDrag.bind(this));
    container.observe('drag:finish',	this.onDragEnd.bind(this));

    if (options.ghosting) {
      this.constructor.Ghost.initialize(this);
    }
  },
  startDragging: function(e) {
    var options = this.options;
    Taskar.Dnd.drag(e.findElement(options.item), e, {
      moveX: options.moveX,
      moveY: options.moveY
    });
  },
  onDragStart: function(e) {
    var options = this.options,
        drag	  = e.memo.element;

    this.changed = false;
    this.drag 	 = drag;
    this.items	 = this.container.select(options.item).reject(function(item) { return item == drag; });
  },
  onDrag: function(e) {
    var hover = this.items.find(function(item) { return Position.within(item, e.memo.x, e.memo.y); });

    if (!hover) return;

    var insert  = Position.overlap('vertical', hover) > 0.5 ? ['previous', 'before'] : ['next', 'after'],
        sibling = hover[ insert[0] ](this.options.item);

    if (sibling == this.drag || sibling == this.ghost) {
      return;
    }

    Element._insertionTranslations[ insert[1] ](hover, this.drag);

    this.changed = true;
    hover.fire('order:changed', {
      sortable: this,
      changed:  hover.up(this.options.list)
    });
  },
  onDragEnd: function(e) {
    if (this.changed) {
      (e.findElement() || this.container).fire('order:updated', { sortable: this });
    }
    this.changed = this.drag = this.items = null;
  },
  serialize: function(name, list) {
    var id, rule = this.constructor.SERIALIZE_RULE;

    name || (name = this.options.name);

    return ($(list) || this.container).select(this.options.item).inject([], function(memo, item) {
      if (id = (item.id && item.id.match(rule)[1])) {
        memo.push( name + '=' + id );
      }
      return memo;
    }).join('&');
  }
});

Taskar.Dnd.Sortable.SERIALIZE_RULE = /\w+_(\d+)/;
Taskar.Dnd.Sortable.DEFAULT_OPTIONS = {
  name:       'items',
  list:       'ul',
  item:       'li',
  handle:     null,
  ghosting:   true,
  moveX:      false,
  moveY:      true,
  autostart:  true
};

Taskar.Dnd.Sortable.Ghost = {
  initialize: function(sortable) {
    sortable.container.observe('drag:before',		this.create.bind(sortable));
    sortable.container.observe('order:changed',	this.swap.bind(sortable));
    sortable.container.observe('drag:finish',   this.remove.bind(sortable));
  },
  create: function(e) {
    this.ghost = $(e.memo.element.cloneNode(true));
    this.ghost.id = null;
    this.ghost.setOpacity(0.5);
    this.ghost.style.position = null;

    e.memo.element.insert({ after: this.ghost });
  },
  swap: function() {
    this.drag.insert({ after: this.ghost });
  },
  remove: function() {
    this.ghost.remove();
    this.ghost = false;
  }
};

Taskar.Dnd.SortableObserver = function(items) {
  items || (items = 'items[]');
  document.on('order:updated', '[data-sortable]', function(e, element) {
    new Ajax.Request(element.getAttribute('data-sortable'), {
      method:     'put',
      parameters: e.memo.sortable.serialize(items)
    });
  });
};