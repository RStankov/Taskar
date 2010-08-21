Taskar.UI.InfoBubble = (function(UI){  
  var InfoBubble = Class.create({
    initialize: function(element, e){
      this.element = $(element);
      this.positionate(e);
    },
    positionate: function(e){
      if (e.findElement('aside')){
        this.element.show().setStyle({
          top: e.pointerY() + 20 + 'px',
          left: e.pointerX() + 'px'
        });
      } else {
        this.element.hide();
      }
    },
    destroy: function(){
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