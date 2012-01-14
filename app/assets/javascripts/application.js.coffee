#= require vendor/jquery
#= require rails
#= require taskar
#= require_self

Taskar.behaviors
  'body':             Taskar.Sections.GlobalBehaviors
  '#sections':        Taskar.Sections.SectionsList.initialize
  '#section_aside':   Taskar.Sections.Aside.initialize
  '#tasks':           Taskar.Sections.TaskList.initialize
  '#tasks_index':     Taskar.Sections.TaskList.behaviors
  '#sections_show':   Taskar.Sections.TaskList.behaviors
  '#tasks_show':      Taskar.Sections.Comments.behaviors
  '#feedback':        Taskar.Sections.Feedback
  '#live_search':     -> new Taskar.LiveSearchForm(this)