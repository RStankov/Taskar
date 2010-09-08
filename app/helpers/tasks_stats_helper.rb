module TasksStatsHelper
  MAX_SUBJECT_LENGTH_NAME = 30
  
  def tasks_stats_subject_name(subject)
    if subject.name && subject.name.mb_chars.length > MAX_SUBJECT_LENGTH_NAME
      content_tag "span", truncate(subject.name, :length => MAX_SUBJECT_LENGTH_NAME), :title => subject.name
    else
      content_tag "span", subject.name
    end
  end
end
