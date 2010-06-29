Factory.define :event do |event|
  event.user    { |a| a.association :user }
  event.subject { |a| a.association :section }
  event.action  'created'
  event.info    'Section "Foo" created'
end
