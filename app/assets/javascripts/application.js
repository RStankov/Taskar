//= require vendor/raphael-min
//= require vendor/prototype
//= require vendor/s2
//= require vendor/cd3widgets

//= require extensions
//= require rails
//= require taskar

//= require_self

CD3.Behaviors({
  'body':                 Taskar.Sections.Global.behaviors,
  '#sections':            Taskar.Sections.SectionsList.initialize,
  '#section_aside':       Taskar.Sections.Aside.initialize,
  '#tasks':               Taskar.Sections.TaskList.initialize,
  '#tasks_index':         Taskar.Sections.TaskList.behaviors,
  '#sections_show':       Taskar.Sections.TaskList.behaviors,
  '#tasks_show':          Taskar.Sections.Comments.behaviors,
  '#feedback':            Taskar.Sections.Feedback,
  '#live_search':         Taskar.UI.LiveSearch.Form,
  'li.tasks_stats ul':    Taskar.Graphics.createPieChart
});

CD3.Behaviors({
  'body': Taskar.UI.StateCheckbox.behaviors
});

CD3.Behaviors({
  'body': Taskar.Dnd.behaviors
});