//= require "vendor/raphael-min"
//= require "vendor/prototype"
//= require "vendor/s2"
//= require "vendor/cd3widgets"

//= require "extensions"
//= require "rails"
//= require "taskar"

CD3.Behaviors({
  '#sections':            Taskar.Sections.SectionsList.initialize,
  '#section_aside':       Taskar.Sections.Aside.initialize,
  '#user_card':           Taskar.Sections.Aside.newStatusForm,
  '#tasks':               Taskar.Sections.TaskList.initialize,
  '#tasks_index':         Taskar.Sections.TaskList.behaviors,
  '#sections_show':       Taskar.Sections.TaskList.behaviors,
  '#tasks_show':          Taskar.Sections.Comments.behaviors,
  '#feedback':            Taskar.Sections.Feedback,
  '#live_search':         Taskar.UI.LiveSearch.Form,
  'li.tasks_stats ul':    Taskar.Graphics.createPieChart
});

CD3.Behaviors(Taskar.Sections.Global.behaviors);

Taskar.UI.StateCheckboxObserver();
Taskar.Dnd.SortableObserver();