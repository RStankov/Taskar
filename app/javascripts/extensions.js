Element.addMethods({
  hideForASecond: function(element){
    element = $(element);
    element.hide();
    element.show.bind(element).defer();
    return element;
  }
});
