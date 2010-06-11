Taskar.FX = {};

Taskar.FX.Move = Class.create(S2.FX.Element, {
  setup: function(){
    this.element.makePositioned();
  
    this.options.x = this.options.x || 0;
    this.options.y = this.options.y || 0;
    
    if (this.options.mode == 'absolute'){
      this.options.x -= parseFloat(this.element.getStyle('left')) || 0;
      this.options.y -= parseFloat(this.element.getStyle('top'))  || 0;
    }

    this.animate('style', this.element, {style: {left: this.options.x + 'px', top:  this.options.y + 'px'}});
  },
  teardown: function(){
    this.element.undoPositioned();
	}
});

Taskar.FX.shake = function(element, options){
  element = $(element);
  
  var options        = Object.extend({distance: 20, duration: 1, turns: 6}, options || {}),
      distance       = -parseFloat(options.distance),
      split          = parseFloat(options.duration) / 10.0,
      turns          = 0,
      maxTurns       = options.turns,
      originalStyle  = { top: element.getStyle('top'), left: element.getStyle('left') };

    function nextEffect(e){
      if (turns < maxTurns){
        distance *= -1;
        turns    += 1;
          
        new Taskar.FX.Move(e.element, nextOptions()).play();
      } else {
        e && e.element.setStyle(originalStyle);
      }
    }
    
  function nextOptions(){
    var radio = turns == 1 || turns == maxTurns ? 1 : 2;
    return {
      y:        0,
      x:        radio * distance,
      duration: radio * split,
      after:    nextEffect
    };
  }
  
  nextEffect({element: element});
};