Given 'a project named "$name" exists in my account' do |name|
  @project = create :project, :name => name, :account => @current_user.accounts.first
end

Given 'a completed project named "$name" exists in my account' do |name|
  @project = create :project, :name => name, :account => @current_user.accounts.first, :completed => true
end

Given '"$user_name" has access to "$project_name" project' do |user_name, project_name|
  project = Project.find_by_name! project_name
  user    = find_user user_name

  project.user_ids = [user.id]
end

When 'I create new project "$name"' do |name|
  click_link 'Projects'
  click_link 'Create new project'

  fill_in :name, :with => name
  check @current_user.full_name
  click_button 'Create'
end

When 'I rename the project to "$name"' do |name|
  visit account_project_path(@project.account, @project)

  click_link 'Edit'

  fill_in :name, :with => name
  click_button 'Save'

  page.should have_content 'Project updated successfully'
end

When 'I complete the project' do
  visit account_project_path(@project.account, @project)

  click_link 'Complete project'
end

When 'I reset the project' do
  step 'I complete the project'
end

When 'I delete the project' do
  visit account_project_path(@project.account, @project)

  click_link 'Delete'
end

When 'I give access to "$project_name" to "$user_name"' do |project_name, user_name|
  project = Project.find_by_name! project_name

  visit account_project_path(project.account, project)

  click_link "Edit"

  check user_name

  click_button 'Save'
end

When 'I revoke the access to "$project_name" to "$user_full_name"' do |project_name, user_full_name|
  project = Project.find_by_name! project_name

  visit account_project_path(project.account, project)

  click_link "Edit"

  uncheck user_full_name

  click_button 'Save'
end

When 'I open "$project_name" project' do |project_name|
  project = Project.find_by_name! project_name

  visit project_sections_path(project)
end

Then 'there should be a project named "$name"' do |name|
  Project.find_by_name(name).should be_present
end

Then 'there should not be a project named "$name"' do |name|
  Project.find_by_name(name).should_not be_present
end

Then 'the project should be completed' do
  @project.reload.should be_completed
end

Then 'the project should not be completed' do
  @project.reload.should_not be_completed
end

Then '"$user_name" should have access to "$project_name" project' do |user_name, project_name|
  project = Project.find_by_name! project_name
  user    = find_user user_name

  project.involves?(user).should be_true
end

Then '"$user_name" should not have access to "$project_name" project' do |user_name, project_name|
  project = Project.find_by_name! project_name
  user    = find_user user_name

  project.involves?(user).should be_false
end

Then "I should see that I don't have access to the project" do
  page.should have_content "You don't have access to this project"
end