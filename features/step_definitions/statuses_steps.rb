When 'I update my status to "$status_text"' do |status_text|
  visit project_sections_path(current_project)

  find('#user_card img').click

  fill_in 'What are you doing?', :with => status_text

  click_button 'Share'

  wait_for_ajax_to_complete

  save
end

Then 'I should have a status "$status_text"' do |status_text|
  project_user = @current_user.project_participations.first
  project_user.status.should eq status_text
end

Then 'I see my updated status on the page to "$status_text"' do |status_text|
  page.should have_content status_text
end