CD3.Behaviors({
  'body:ajax:after': {
    '.action_form':       function(e, element){
                            if (element.getAttribute('data-disable') !== 'false'){
                              element.addClassName('loading');
                              element.getElements().invoke('disable');
                            }
                          },
    '.edit':              function(e, element){
                            element.addClassName('loading');
                            element.style.textDecoration = 'none';
                            element.innerHTML = element.innerHTML.gsub(/./, '&nbsp;');
                          }
  },
  '#sections':            function(){
                            Taskar.Sections.Ordering(this);
                            Taskar.Sections.NewSection(this);
                          },
  '#section_title':       Taskar.Sections.Title,
  '#sections_show':       Taskar.Sections.Actions,
  '#tasks_index':         Taskar.Sections.Actions,
  '#section_aside':       Taskar.Sections.Aside.initialize,
  '#user_card':           Taskar.Sections.NewStatus,
  '#tasks':               Taskar.Sections.TaskList,
  '#tasks_show':          Taskar.Sections.Comments,
  '#feedback':            Taskar.Sections.Feedback,
  'body':                 Taskar.Dnd.Sortable.AjaxSave,
  '#live_search':         Taskar.UI.LiveSearch.Form,
  'li.tasks_stats ul':    Taskar.Graphics.createPieChart,
  '#statuses_list:ajax:delete': function(e){ Taskar.FX.dropOut(e.findElement('li'), function(e){e.element.remove()}); },
  '#tasks_show:ajax:put': {
    '.archive': function(e){
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
  '#scroll_to_top:click': function(e){
                            e.stop();

                            var id      = this.getAttribute('href').split('#').last(),
                                element = $(id);

                            element && new Taskar.FX.ScrollTo(element, function(){ location.hash = id; });
                          }
});