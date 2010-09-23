module SectionsHelper
  def section_is_dashboard?
   (controller_name == "sections" || controller_name == "statuses") && action_name == "index"
  end

  def section_is_tasks?
    @section && !@section.archived?
  end

  def section_is_archive?
    (@section && @section.archived?) || (controller_name == "sections" && action_name == "archived")
  end

  def new_section_link(before = nil)
    before = before.id.to_s if before
    href   = new_project_section_path(@project, :before => before)

    link_to insert_at(t "layouts.sections.new_section"), href, :class => "add_section", "data-before" => before
  end

  def participant_task_count(count)
    t "layouts.sections.tasks", :count => count
  end

  def participant_last_action(participant)
    t "layouts.sections.last_activity", :time => time_ago_in_words(participant.user.last_active_at)
  end

  def participant_status_title(participant)
    unless participant.status.blank?
      if participant.status.size < 100
        participant_last_action participant
      else
        participant.status + "\n\n" + participant_last_action(participant)
      end
    end
  end

  def participant_status(participant)
    if participant.status.blank?
      participant_last_action participant
    else
      simple_format participant.status
    end
  end
end