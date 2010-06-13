Element.addMethods({
  replaceClassName: function(element, oldClassName, newClassName){
    element = $(element);
    element.className = element.className.replace(oldClassName, newClassName);
    return element;
  }
});

Taskar.UI.StateCheckboxObserver = (function(){
  function nextState(state){
    switch(state){
      case 'opened':    return 'completed';
      case 'completed': return 'rejected';
      case 'rejected':  return 'opened';
    }
    return 'opened';
  }
  
  function changeState(element){
    var current = element.getAttribute('data-state'),
        next    = nextState(current);
    
    element.setAttribute('data-state', next);
    element.replaceClassName(current, next);
    element.up('.task').replaceClassName(current, next);
  }
  
  function clearTimer(element){
    var timer = element.retrieve('state:timer');
    if (timer){ 
      clearTimeout(timer);
      element.store('state:timer', null);
    }
  }
  
  function setTimer(element){
    element.store('state:timer', setTimeout(function(){
      element.store('state:timer', null);
      element.fire('state:changed', {state: element.getAttribute('data-state')});
    }, 500));    
  }
  
  return function(e, element){
    changeState(element);
    clearTimer(element);
    setTimer(element);
  };
})();