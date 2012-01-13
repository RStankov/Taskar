Taskar.UI.StateCheckbox = {
  behaviors: {
    'click': {
      '.checkbox[data-disabled!=true]': (function(){
        var STATES = {
          'opened':     'completed',
          'completed':  'rejected',
          'rejected':   'opened'
        };

        function changeState(element){
          var current = element.getAttribute('data-state'),
              next    = STATES[current] || 'opened',
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
            element.store('state:timer', null).fire('state:changed', {state: element.getAttribute('data-state')});
          }, 500));
        }

        return function(e, element){
          clearTimer(element);
          changeState(element);
          setTimer(element);
        };
      })()
    },
    'state:changed': {
      '.checkbox': function(e, checkbox){
        new Ajax.Request(checkbox.getAttribute('data-url'), {
          method:     'put',
          parameters: {state: checkbox.getAttribute('data-state')}
        });
      }
    }
  }
};