Taskar.UI.TooltipBubble = (function(UI){  
  var Widget = Class.create({
    initialize: function(element, e, text){
      this.element = $(element);
      
      text && this.element.update(text);
      
      this.positionate(e);
    },
    positionate: function(e){
      this.element.setStyle({
        display:  "block",
        top:      Event.pointerY(e) + 20 + "px",
        left:     Event.pointerX(e) + 10 + "px"
      });
    },
    destroy: function(){
      this.element.hide();
      this.element = null;
    }
  });
  
  function createTooltip(e, text){
    this.instance = new Widget("info_bubble", e, text);
    this.move     = moveTooltip;
    return this;
  }
  
  function moveTooltip(e){
    this.instance.positionate(e);
    return this;
  }
  
  return {
    instance: null,
    show:     createTooltip,
    move:     createTooltip,
    hide:     function(){
      if (this.instance){
        this.instance.destroy();
        this.instance = null;
        this.move = createTooltip;
      }
    }
  };
})();