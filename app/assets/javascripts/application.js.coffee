#= require vendor/jquery
#= require vendor/jquery_ui

#= require rails
#= require taskar
#= require_self

Taskar.behaviors
  'body':             Taskar.GlobalBehaviors
  '#sections':        Taskar.SectionsList.initialize
  '#section_aside':   Taskar.Aside.initialize
  '#tasks':           Taskar.TaskList.initialize
  '#tasks_index':     Taskar.TaskList.behaviors
  '#sections_show':   Taskar.TaskList.behaviors
  '#tasks_show':      Taskar.Comments.behaviors
  '#feedback':        Taskar.Feedback
  '#live_search':     -> new Taskar.LiveSearchForm(this)