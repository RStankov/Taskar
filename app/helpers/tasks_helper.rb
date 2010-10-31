module TasksHelper
  def task_state_checkbox(task)
    state = task.state

    attributes = 'class="checkbox ' + state + '" data-state="' + state + '" data-url="' + state_task_path(task) + '"'
    attributes << ' data-disabled="true"' if task.archived?

    "<span #{attributes}></span>".html_safe
  end

  def task_archive_button(task)
    link_to '', archive_task_path(task), :class => "archive", "data-remote" => true, "data-method" => "put"
  end

  def task_description(task)
    name    = "short"
    options = {
      :task => t("tasks.show.task.#{task.archived ? 'archived' : 'normal'}"),
      :from => task.user.full_name,
      :on   => time_ago_in_words(task.created_at)
    }

    if task.responsible_party
      if task.responsible_party == task.user
        name = "same"
      else
        name = "responsible"
        options[:to] = task.responsible_party.full_name
      end
    end

    t("tasks.show.description.#{name}", options)
  end
end