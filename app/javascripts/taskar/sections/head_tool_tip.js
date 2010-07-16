Taskar.Sections.HeadToolTip = function(element){
  var tooltip = element.down('.tooltip').show(),
      offset  = (tooltip.getWidth()/2).round(),
      arrow   = tooltip.down('.arrow'),
      hide    = Element.hide.curry(tooltip);
      
  arrow.style.left = (offset - (arrow.getWidth() / 2).round()) + 'px';
  
  tooltip.hide();
  
  element.on('mouseover', '.add_section', function(e, element){
    tooltip.style.left = (element.positionedOffset().left - offset) + 'px';
    tooltip.show();
  })
  

  element.on('click', '.add_section', hide);
  element.on('mouseout', '.add_section', hide);
};