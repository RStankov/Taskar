Factory.define :section do |section|
  section.name              { "Test section" }
  section.project           { |a| a.association :project }
end
