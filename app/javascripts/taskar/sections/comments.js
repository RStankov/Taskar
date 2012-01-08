Taskar.Sections.Comments = {
  behaviors: {
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