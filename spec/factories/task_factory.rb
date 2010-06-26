Factory.define :task do |task|
  task.section           { |a| a.association :section }
  task.project           { |a| a.association :project }
  task.text              "Task Text"
  task.status            0
end
