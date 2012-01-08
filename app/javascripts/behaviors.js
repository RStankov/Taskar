CD3.Behaviors({
  '#sections':            function(){
                            Taskar.Sections.Ordering(this);
                            Taskar.Sections.NewSection(this);
                          },
  '#section_aside':       Taskar.Sections.Aside.initialize,
  '#user_card':           Taskar.Sections.NewStatus,
  '#tasks':               Taskar.Sections.TaskList.initialize,
  '#tasks_index':         Taskar.Sections.TaskList.behaviors,
  '#sections_show':       Taskar.Sections.TaskList.behaviors,
  '#tasks_show':          Taskar.Sections.Comments.behaviors,
  '#feedback':            Taskar.Sections.Feedback,
  'body':                 Taskar.Dnd.Sortable.AjaxSave,
  '#live_search':         Taskar.UI.LiveSearch.Form,
  'li.tasks_stats ul':    Taskar.Graphics.createPieChart
});

CD3.Behaviors(Taskar.Sections.Global.behaviors);