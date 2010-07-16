Taskar.Sections.HeadToolTip = function(element){
  var tooltip = element.down('.tooltip').show(),
      arrow   = tooltip.down('.arrow'),
      hide    = Element.hide.curry(tooltip);
      
  arrow.style.left = ((tooltip.getWidth() - arrow.getWidth()) / 2).round() + 'px';
  
  tooltip.hide();
  
  element.on('mouseover', '.add_section', function(e, element){
    tooltip.style.left = element.positionedOffset().left + 'px';
    tooltip.show();
  })
  

  element.on('click', '.add_section', hide);
  element.on('mouseout', '.add_section', hide);
};