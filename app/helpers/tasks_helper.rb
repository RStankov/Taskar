module TasksHelper
  def task_state_checkbox(task)
    state = task.state
    '<span class="checkbox ' + state + '" data-state="' + state + '" data-url="' + state_task_path(task) + '"></span>'
  end
end