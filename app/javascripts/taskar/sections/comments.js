Taskar.Sections.Comments = {
  click: {
    '.delete': function(e, element){
      e.stop();
      element.request({
        method: 'delete',
        onCreate: function(){
          element.up('.comment').removeWithEffect('slideUp');
        }
      });
    }
  }
};