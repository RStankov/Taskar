Taskar.Sections = {
  validateForm: function(e){
    var input = e.findElement('form').down('input[type=text],textarea');
    if (input.getValue().trim().length == 0){
      e.stop();
      Taskar.FX.shake(input, {distance: 2, turns: 2});
      
      input.style.backgroundColor = null;
      input.highlight({startColor: Taskar.ERROR_COLOR});
      input.focus();
    }
  },
  resetTaskForm: function(form, before){
    this.resetForm(form);
    
    if (before !== false){
      form.down('input[name*=insert_after]').setValue(before || null);
    }
  },
  resetForm: function(form){
    form.reset();
    
    var errors = form.down('.error_messages');
    if (errors){
      errors.remove();
      form.select('.fieldWithErrors').each(function(element){
        element.replace(element.down());
      });
    }
  }
};

//= require "sections/new_form"
//= require "sections/ordering"
//= require "sections/slider"
//= require "sections/head_tool_tip"
//= require "sections/actions"
//= require "sections/title"
//= require "sections/init_task_list"
//= require "sections/comments"
//= require "sections/aside"
//= require "sections/user_card"
