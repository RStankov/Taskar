Given 'there is a task list "$name"' do |name|
  create :section, :name => name, :project => current_project
end

When 'I add a task list "$name"' do |name|
  click_link 'Create task list'

  fill_in 'Name', :with => name

  click_button 'Create'
end

When 'I rename "$current_name" task list to "$new_name"' do |current_name, new_name|
  click_link current_name

  click_link 'Edit'

  wait_for_ajax_to_complete

  sleep 1

  fill_in 'Name', :with => new_name

  click_button 'Save'

  wait_for_ajax_to_complete
end

When 'I delete "$name" task list' do |name|
  click_link name

  confirm_on_next_action

  click_link 'Delete'
end

Then 'there should be a "$name" task list in the project' do |name|
  current_project.sections.find_by_name(name).should be_present
end

Then 'there should not be a "$name" task list in the project' do |name|
  current_project.sections.find_by_name(name).should_not be_present
end