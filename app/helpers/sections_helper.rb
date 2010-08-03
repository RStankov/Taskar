module SectionsHelper
  def new_section_link(before = nil)
    before = before.id.to_s if before
    
    content_tag(:li, :class => "add_section", :"data-before" => before) do
      link_to("&nbsp;", new_project_section_path(@project, :before => before))
    end
  end
  
  def participant_last_action(participant)
    t :".last_activity", :time => time_ago_in_words(participant.user.last_active_at)
  end
  
  def participant_status_title(participant)
    if participant.status
      if participant.status.size < 100
        participant_last_action participant
      else
        h(participant.status) + "\n\n" + participant_last_action(participant)
      end
    end
  end
  
  def participant_status(participant)
    if participant.status
      simple_format h(participant.status)
    else  
      participant_last_action participant
    end
  end
end