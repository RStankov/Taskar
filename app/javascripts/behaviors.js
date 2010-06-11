CD3.Behaviors({
  '#nav_sections': {
    'click': {
      '.add_section': function(e, element){
        var form = $('new_section');
        form.show();
        form.down('form').reset();
      
        element.insert({before: form.show()});
      
        form.down('input[type=text]').focus();
      
        element.hide()
        element.show.bind(element).defer();
      },
      'input[type=button]': function(e){
        e.findElement('li').hide();
      }
    },
    'keyup': {
      'form': function(e){
        if (e.keyCode == Event.KEY_ESC){
          e.findElement('li').hide();
        }
      }
    },
    'submit': {
      'form': function(e, form){
        var input = form.down('input[type=text]');
        if (input.getValue().trim().length == 0){
          e.stop();
          Taskar.FX.shake(input, {distance: 2, turns: 2});
          new S2.FX.Highlight(input).play();
        }
      }
    },
    'focus:out': {
      'input': function(e, input){
        if (input.getValue().trim().length == 0){
          e.stop();
          Taskar.FX.shake(input, {distance: 2, turns: 2});
          new S2.FX.Highlight(input).play();
        }
      }
    }
  }
})