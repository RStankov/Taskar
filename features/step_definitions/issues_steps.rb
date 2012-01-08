When 'I report issue about "$issue_description"' do |issue_description|
  click_link 'Feedback'

  fill_in 'problem', :with => issue_description

  click_button 'Share'
  
  wait_for_ajax_to_complete
end

Then 'there should be an issue about "$issue_description" on $issue_url' do |issue_description, issue_url|
  issue = Issue.find_by_description! issue_description
  issue.url.should eq path_to(issue_url)
end