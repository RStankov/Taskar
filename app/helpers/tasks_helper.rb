module TasksHelper
  def task_state_checkbox(task)
    state = task.state
    '<span class="checkbox ' + state + '" data-state="' + state + '" data-url="' + task_path(task) + '"></span>'
  end
end