Taskar.UI.StateCheckboxObserver = function(){
  document.on('click', '.checkbox[data-state]', Taskar.UI.StateCheckboxObserver.callback);
  document.on('state:changed', '.checkbox', function(e, checkbox){
    new Ajax.Request(checkbox.getAttribute('data-url'), {
      method:     'put',
      parameters: {state: checkbox.getAttribute('data-state')}
    });
  });
};

Taskar.UI.StateCheckboxObserver.callback = (function(){
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
        next    = nextState(current),
        parent  = element.up('.task');
    
    element.setAttribute('data-state', next);
    element.replaceClassName(current, next);
    
    if (parent){
      parent.replaceClassName(current, next);
    }
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