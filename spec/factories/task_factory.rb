Factory.define :task do |task|
  task.section           { |a| a.association :section }
  task.project           { |a| a.association :project }
  task.user              { |a| a.association :user }
  task.text              "Task Text"
  task.status            0
end
