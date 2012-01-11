Taskar.UI.HoverBubble = (function(UI){  
  var Widget = Class.create({
    initialize: function(element, showOn, hoverOn, e){
      this.element        = $(element);
      this.hoverElement   = null;
      this.showOn         = showOn;
      this.hoverOn        = hoverOn;
      this.positionate(e);
    },
    positionate: function(e){
      if (e.findElement(this.showOn)){
        this.hoverOn && this.hover(e.findElement(this.hoverOn));
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
    this.instance = new Widget('info_bubble', 'aside', '.link:not(.selected)', e);
    this.move     = moveWidget;
  }
  
  function moveWidget(e){
    this.instance.positionate(e);
  }
  
  return {
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
})();