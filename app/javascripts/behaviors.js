CD3.Behaviors({
  '#sections':            function(){
                            Taskar.Sections.Ordering(this);
                            Taskar.Sections.NewSection(this);
                          },
  '#section_title':       Taskar.Sections.Title,
  '#sections_show':       Taskar.Sections.Actions,
  '#tasks_index':         Taskar.Sections.Actions,
  '#section_aside':       Taskar.Sections.Aside.initialize,
  '#user_card':           Taskar.Sections.NewStatus,
  '#tasks':               Taskar.Sections.initTaskList,
  '#tasks_show':          Taskar.Sections.Comments,
  'body':                 Taskar.Dnd.Sortable.AjaxSave,
  '#live_search':         Taskar.UI.LiveSearch.Form,
  '#statuses_list:ajax:delete': function(e){ Taskar.FX.dropOut(e.findElement('li'), function(e){e.element.remove()}); },
  '#scroll_to_top:click': function(e){
                            e.stop();
                            var element, id = this.getAttribute('href').split('#').last();

                            if (element = $(id)) new Taskar.FX.ScrollTo(element, function(){ location.hash = id; });
                          }
});