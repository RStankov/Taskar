Factory.define :comment do |comment|
  comment.user           { |a| a.association :user }
  comment.task           { |a| a.association :task }
  comment.text           "Comment Text"
end
