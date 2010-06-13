Taskar.Sections.Tasks = {
  click: {
    '.cancel': function(e, element){
      e.findElement('li').slideUp();
    },
    '.delete': function(e, element){
      e.stop();
      element.request({
        method: 'delete',
        onCreate: function(){
          element.up('.task').removeWithEffect('slideUp');
        }
      });
    },
    '.checkbox': Taskar.UI.StateCheckboxObserver
  },
  'state:changed': function(e) {
    var checkbox = e.findElement('.checkbox');
    if (checkbox){
      new Ajax.Request(checkbox.getAttribute('data-url'), {
        method:     'put',
        parameters: {state: checkbox.getAttribute('data-state')}
      });
    }
  }
};
