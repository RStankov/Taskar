Factory.define :stataus do |event|
  event.user     { |a| a.association :user }
  event.subject  { |a| a.association :task }
  event.text     'doing something'
end
