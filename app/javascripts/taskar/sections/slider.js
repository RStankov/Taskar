Taskar.Sections.Slider = function(element){
  var width       = element.select('li').invoke('getWidth').reduce(function(s, v){return s+=v}),
      parent      = element.up(),
      maxWidth    = parent.getWidth(),
      leftRange   = 300,
      rightRange  = maxWidth - leftRange,
      minSlide    = maxWidth * 2 - width;
  
  if (width <= maxWidth){
    return;
  }
  
  element.style.width = width + 'px';
  console.log(maxWidth - width, maxWidth, width);
  var slide = new PeriodicalExecuter(function(timer){
    var position = (parseInt(element.style.marginLeft, 10) || 0) - timer.speed * 10;

    element.style.marginLeft = position.constrain(minSlide, 0) + 'px';
  }, 0.05);
  slide.start = function(speed){
    this.speed = speed;
    !this.timer && this.registerCallback();
  };
  slide.stop();
  
  
  element.observe('mousemove', function(e){
    var left = e.pointerX() - parent.offsetLeft;
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