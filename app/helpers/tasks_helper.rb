module TasksHelper
  def task_state_checkbox(task)
    state = task.state
    
    if task.archived?
      '<span class="checkbox ' + state + '"></span>'
    else 
      '<span class="checkbox ' + state + '" data-state="' + state + '" data-url="' + state_task_path(task) + '"></span>'
    end
  end
  
  def task_description(task)
    #TODO more advanced description logic
    '<p>' + t(:'tasks.show.description', :from => task.user.full_name, :to => 'Някой друг', :on => t(:before, :time => time_ago_in_words(task.created_at)), :due => '10.05.2010') + '</p>'
  end
end