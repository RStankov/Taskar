Factory.define :comment do |comment|
  comment.user           { |a| a.association :user }
  comment.task           { |a| a.association :task }
  comment.project        { |a| a.association :project }
  comment.text           "Comment Text"
end
