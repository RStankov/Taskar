class TasksStats
  STATS = {
    :opened     => "blue", 
    :rejected   => "red",
    :completed  => "green"
  }
  
  def initialize(subject)
    @statistics = STATS.inject(Hash.new) do |hash, (type, color)|
      size = subject.tasks.send(type).size
      hash[type] = size if size > 0
      hash
    end
  end
  
  def needed?
    @statistics.size > 1
  end
  
  def empty_text
    if @statistics.size == 0
      I18n.t "tasks_stats.empty.tasks"
    else
      type = @statistics.keys.first
      I18n.t "tasks_stats.empty.#{type}", :count => @statistics[type]
    end
  end
end