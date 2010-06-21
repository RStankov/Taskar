Factory.define :project_user do |section|
  section.project       { |a| a.association :project }
  section.user          { |a| a.association :user }
end
