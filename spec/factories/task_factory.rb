Factory.define :task do |task|
  task.section           { |a| a.association :section }
  task.text              "Task Text"
  task.status            0
end
