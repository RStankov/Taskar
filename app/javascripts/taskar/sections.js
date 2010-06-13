Taskar.Sections = {
  validateForm: (function(){
    var highlight = new S2.FX.Highlight(new Element('div'), {after: function(e){ e.element.style.backgroundColor = null; }});
    return function(e){
      var input = e.findElement('form').down('input[type=text]');
      if (input.getValue().trim().length == 0){
        e.stop();
        Taskar.FX.shake(input, {distance: 2, turns: 2});
        highlight.play(input);
      }
    }
  })()
}

//= require "sections/new_form"
//= require "sections/title"
//= require "sections/tasks"
