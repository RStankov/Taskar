Taskar.Sections.Comments = {
  behaviors: {
    'ajax:put': {
      '.task .archive': function(e){
        var task = e.findElement('.task');
        if (task){
          var newComment = $('new_comment');
          if (task.hasClassName('archived')){
            task.removeClassName('archived');
            task.down('.checkbox').writeAttribute('data-disabled', null);
            newComment && newComment.slideDown();
          } else {
            task.addClassName('archived');
            task.down('.checkbox').writeAttribute('data-disabled', 'true');
            newComment && newComment.slideUp();
          }
        }
      }
    },
    'ajax:delete': {
      '.comment': function(e, element){
        element.removeWithEffect('slideUp');
      }
    },
    'key:esc': {
      'form': Taskar.Sections.cancelAction
    }
  },
  actions: {
    show: function(elementId, html, commentsCount) {
      var comment = $(elementId);

      if (comment){
        comment.replaceWithEffect(html);
      } else {
        Taskar.Sections.resetForm($("new_comment"));
        $("comments").show().down("ul").insert({bottom: html});
        $(elementId).hide().slideDown();
        $("comments_count").update(commentsCount || 1);
      }
    },
    errorOnNew: function(html) {
      $('new_comment').replace(html).down('textarea').highlight({startColor: Taskar.ERROR_COLOR}).focus();
    },
    edit: function(elementId, html) {
      $(elementId).transform(html);
    },
    afterDestroy: function(commetnsCount) {
      if (commetnsCount == 0) {
        $('comments').slideUp("fast");
      } else {
        $('comments_count').update(commetnsCount);
      }
    }
  }
};