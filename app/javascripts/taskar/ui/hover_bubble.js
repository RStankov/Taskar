Taskar.UI.HoverBubble = (function(UI){  
  var Widget = Class.create({
    initialize: function(element, e){
      this.element        = $(element);
      this.hoverElement   = null;
      this.positionate(e);
    },
    positionate: function(e){
      if (e.findElement('aside')){
        this.hover(e.findElement('.link:not(.selected)'));
        this.element.setStyle({
          display:  'block',
          top:      e.pointerY() + 20 + 'px',
          left:     e.pointerX() + 'px'
        });
      } else {
        this.element.hide();
      }
    },
    hover: function(element){
      if (element != this.hoverElement){
        this.hoverElement && this.hoverElement.removeClassName('hover');
        this.hoverElement = element && element.addClassName('hover');
      }
    },
    unhover: function(){
      if (this.hoverElement){
        this.hoverElement.removeClassName('hover');
        this.hoverElement = null;
      }
    },
    destroy: function(){
      this.unhover();
      this.element.hide();
      this.element = null;
    }
  });
  
  function createWidget(e){
    this.instance = new Widget('info_bubble', e);
    this.move     = moveWidget;
  }
  
  function moveWidget(e){
    this.instance.positionate(e);
  }
  
  var controller = {
    instance: null,
    move:     createWidget,
    hide:     function(){
      if (this.instance){
        this.instance.destroy();
        this.instance = null;
        this.move = createWidget;
      }
    }
  };
  
  return controller;
})();