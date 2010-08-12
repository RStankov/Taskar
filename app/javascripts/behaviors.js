CD3.Behaviors({
  '#nav_main':            Taskar.Sections.HeadToolTip,
  '#nav_sections ul':     function(){
                            Taskar.Sections.Slider(this);
                            Taskar.Sections.Ordering(this);
                            Taskar.Sections.NewForm(this);
                          },
  '#section_title':       Taskar.Sections.Title,
  '#sections_show':       Taskar.Sections.Actions,
  '#tasks_index':         Taskar.Sections.Actions,
  '#section_aside':       Taskar.Sections.Aside.initialize,
  '#user_card':           Taskar.Sections.NewStatus,
  '#tasks':               Taskar.Sections.initTaskList,
  '#tasks_show':          Taskar.Sections.Comments,
  '#live_search':         Taskar.UI.LiveSearch.Form,
  '#scroll_to_top:click': function(e){
                            e.stop();
                            var element, id = this.getAttribute('href').split('#').last();

                            if (element = $(id)) new Taskar.FX.ScrollTo(element, function(){ location.hash = id; });
                          }
});