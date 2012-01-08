module AsideHelper
  def aside_javascript_options
    {
      :events            => @unseen_events_count,
      :eventsText        => t("aside.unseen_events", :count => @unseen_events_count),
      :responsibilities  => participant_task_count(@responsibilities_count),
      :participants      => aside_javascript_participants_array
    }
  end

  private

  def aside_javascript_participants_array
    @participants.map do |participant|
      {
        :elementId => dom_id(participant),
        :title     => participant_status_title(participant),
        :status    => participant_status(participant)
      }
    end
  end
end