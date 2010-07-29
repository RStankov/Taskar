Factory.define :status do |event|
  event.user     { |a| a.association :user }
  event.project  { |a| a.association :project }
  event.text     'doing something'
end
