Taskar.UI.InfoBubble = (function(UI){  
  var InfoBubble = Class.create({
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
  
  function moveBubble(e){
    this.instance.positionate(e);
  }
  
  function createBubble(e){
    this.instance = new InfoBubble('info_bubble', e);
    this.move     = moveBubble;
  }
  
  var widget = {
    instance: null,
    move:     createBubble,
    hide:     function(){
      if (this.instance){
        this.instance.destroy();
        this.instance = null;
        this.move = createBubble;
      }
    }
  };
  
  return widget;
})();