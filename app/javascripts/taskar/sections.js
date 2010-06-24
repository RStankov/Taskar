Taskar.Sections = {
  validateForm: function(e){
    var input = e.findElement('form').down('input[type=text]');
    if (input.getValue().trim().length == 0){
      e.stop();
      Taskar.FX.shake(input, {distance: 2, turns: 2});
      
      input.highlight({startColor: Taskar.ERROR_COLOR});
      input.focus();
    }
  },
  resetTaskForm: function(form){
    form.reset();
    
    var errors = form.down('.errorExplanation');
    if (errors){
      errors.remove();
      form.select('.fieldWithErrors').each(function(element){
        element.replace(element.down());
      });
    }
  }
};

//= require "sections/new_form"
//= require "sections/title"
//= require "sections/tasks"
//= require "sections/footer"
//= require "sections/comments"
