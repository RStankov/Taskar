Given 'a project named "$name" exists in my account' do |name|
  @project = create :project, :name => name, :account => @current_user.accounts.first
end

Given 'a completed project named "$name" exists in my account' do |name|
  @project = create :project, :name => name, :account => @current_user.accounts.first, :completed => true
end

Given 'several sections, tasks and comments associated to the project' do
  section = create :section, :project => @project
  task    = create :task, :section => section
  comment = create :comment, :task => task, :project => @project
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

Then 'there should not be any sections, tasks and comments' do
  Section.count.should eq 0
  Task.count.should eq 0
  Comment.count.should eq 0
end