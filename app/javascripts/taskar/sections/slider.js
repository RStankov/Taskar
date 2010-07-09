Taskar.Sections.Slider = function(element){
  var width       = element.select('li.section').invoke('getWidth').reduce(function(s, v){ return s += v + 10; }),
      container   = element.up(),
      maxWidth    = container.getWidth(),
      leftRange   = 300,
      rightRange  = maxWidth - leftRange;

  element.style.width = width + 'px';
  
  var slide = new PeriodicalExecuter(function(timer){
    container.scrollLeft += timer.speed * 10;
  }, 0.05);
  slide.start = function(speed){
    this.speed = speed;
    !this.timer && this.registerCallback();
  };
  slide.stop();
  
  
  element.observe('mousemove', function(e){
    var left = e.pointerX() - container.offsetLeft;
    if (left < leftRange){
      slide.start((left - leftRange)/leftRange)
    } else if (left > rightRange){
      slide.start((left - rightRange)/leftRange);
    } else {
      slide.stop();
    }
  });
  
  element.observe('mouseleave', function(e){
    slide.stop();
  });
};