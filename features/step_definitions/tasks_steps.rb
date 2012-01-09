Given 'a task "$text"' do |text|
  section = current_project.sections.first || create(:section, :project => current_project)
  create :task, :text => text, :section => section
end