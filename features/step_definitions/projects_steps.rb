Given '"$project_name" project exists for "$account_name"' do |project_name, account_name|
  account = Account.find_by_name(account_name) || Factory(:account, :name => account_name)
  @project = Factory(:project, :name => project_name, :account => account)
end

Then 'the project should be completed' do
  @project.reload.should be_completed
end

Then 'the project should not be completed' do
  @project.reload.should_not be_completed
end
