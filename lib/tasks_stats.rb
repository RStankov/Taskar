class TasksStats
  extend ActiveModel::Naming

  STATS = {
    :opened     => "blue",
    :rejected   => "red",
    :completed  => "green"
  }

  Chunk = Struct.new(:type, :size, :text, :color)

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
      I18n.t "tasks_stats.empty"
    else
      text_for @statistics.keys.first
    end
  end

  def text_for(type)
    I18n.t "tasks_stats.#{type}", :count => @statistics[type]
  end

  def stats
    @statistics.each do |(type, size)|
      yield Chunk.new(type, size, text_for(type), STATS[type])
    end
  end
end