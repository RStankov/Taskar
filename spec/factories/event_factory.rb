Factory.define :event do |event|
  event.user    { |a| a.association :user }
  event.subject { |a| a.association :task }
  event.action  'created'
  event.info    'Section "Foo" created'
end
