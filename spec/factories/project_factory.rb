Factory.sequence :name do |n|
  "generated_name_#{n}"
end

Factory.define :project do |project|
  project.name             { Factory.next :name }
end
