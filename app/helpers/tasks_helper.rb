module TasksHelper
  def task_state_checkbox(task)
    state = task.state
    '<span class="checkbox ' + state + '" data-state="' + state + '" data-url="' + state_task_path(task) + '"></span>'
  end
  
  def task_description(task)
    '<p>' + t(:'tasks.show.description', :from => 'Радослав Станков', :to => 'Някой друг', :on => '10.05.2010', :due => '10.05.2010') + '</p>'
  end
end