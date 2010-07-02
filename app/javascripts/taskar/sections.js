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
  resetTaskForm: function(form, before){
    form.reset();
    
    var errors = form.down('.errorExplanation');
    if (errors){
      errors.remove();
      form.select('.fieldWithErrors').each(function(element){
        element.replace(element.down());
      });
    }
    
    if (before !== false){
      form.down('input[name*=insert_after]').setValue(before || null);
    }
  }
};

//= require "sections/new_form"
//= require "sections/actions"
//= require "sections/title"
//= require "sections/ordering"
//= require "sections/init_task_list"
//= require "sections/comments"
//= require "sections/aside"
