Given 'I have set my status to "$status_text"' do |status_text|
  create :status, :text => status_text, :user => @current_user, :project => current_project
end

When 'I clear my status' do
  visit project_sections_path(current_project)

  click_link 'clear status'

  wait_for_ajax_to_complete
end

When 'I update my status to "$status_text"' do |status_text|
  visit project_sections_path(current_project)

  find('#user_card img').click

  fill_in 'What are you doing?', :with => status_text

  click_button 'Share'

  wait_for_ajax_to_complete
end

When 'I delete my "$status_text" status' do |status_text|
  visit project_sections_path(current_project)

  click_link 'Statuses'
  click_link 'Delete'
end

Then 'there should not be a "$status_text" status' do |status_text|
  Status.find_by_text(status_text).should_not be_present
end

Then 'I should have a status "$status_text"' do |status_text|
  project_user = @current_user.project_participations.first
  project_user.status.should eq status_text
end

Then 'I see my updated status on the page to "$status_text"' do |status_text|
  page.should have_content status_text
end

Then 'I should have no status' do
  project_user = @current_user.project_participations.first
  project_user.status.should be_empty
end
