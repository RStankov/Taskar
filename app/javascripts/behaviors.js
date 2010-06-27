CD3.Behaviors({
  '#nav_sections':        function(){
                            Taskar.Sections.NewForm(this);
                            Taskar.Sections.Ordering(this);
                          },
  '#section_title':       Taskar.Sections.Title,
  '#sections_show':       Taskar.Sections.Actions,
  '#section_aside':       Taskar.Sections.Aside,
  '#tasks':               Taskar.Sections.initTaskList,
  '#comments':            Taskar.Sections.Comments,
  '#live_search':         Taskar.UI.LiveSearch.Form,
  '#scroll_to_top:click': function(e){
                            e.stop();
                            var element, id = this.getAttribute('href').split('#').last();

                            if (element = $(id)) new Taskar.FX.ScrollTo(element, function(){ location.hash = id; });
                          }
});