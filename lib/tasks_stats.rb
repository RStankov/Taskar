class TasksStats
  STATS = {
    :opened     => "blue", 
    :rejected   => "red",
    :completed  => "green"
  }
  
  def initialize(subject)
    @statistics = STATS.inject(Hash.new) do |hash, (type, color)|
      size = subject.tasks.send(type).size
      p size
      hash[type] = size if size > 0
      hash
    end
  end
  
  def needed?
    @statistics.size > 1
  end
end