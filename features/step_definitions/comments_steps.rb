Given 'I a comment "$comment_text" on "$task_text"' do |comment_text, task_text|
  task = Task.find_by_text! task_text

  create :comment, :text => comment_text, :task => task
end

Given 'I have made a comment "$comment_text" on "$task_text"' do |comment_text, task_text|
  task = Task.find_by_text! task_text

  create :comment, :text => comment_text, :task => task, :user => @current_user
end

Given 'I have made a comment "$comment_text" on "$task_text" before $count minutes ago' do |comment_text, task_text, count|
  task = Task.find_by_text! task_text

  create :comment, :text => comment_text, :task => task, :user => @current_user, :updated_at => count.to_i.minutes.ago
end

When 'I comment on "$task_text" with "$comment_text"' do |task_text, comment_text|
  task = Task.find_by_text! task_text

  visit task_path(task)

  fill_in 'New comment', :with => comment_text

  click_button 'Add comment'

  wait_for_ajax_to_complete

  page.should have_content(comment_text)
end

When 'I update the "$current_text" comment on "$task_text" with "$new_text"' do |current_text, task_text, new_text|
  task    = Task.find_by_text! task_text
  comment = Comment.find_by_text! current_text

  visit task_path(task)

  with_scope "#comment_#{comment.id}" do
    click_link 'Edit'

    wait_for_ajax_to_complete

    fill_in 'comment[text]', :with => new_text

    click_button 'Change'

    wait_for_ajax_to_complete
  end
end

When 'I delete the "$comment_text" comment on "$task_text"' do |comment_text, task_text|
  task    = Task.find_by_text! task_text
  comment = Comment.find_by_text! comment_text

  visit task_path(task)

  with_scope "#comment_#{comment.id}" do
    confirm_on_next_action

    click_link 'Delete'

    wait_for_ajax_to_complete
  end
end

Then 'there should be a "$comment_text" comment on "$task_text" task' do |comment_text, task_text|
  task = Task.find_by_text! task_text
  task.comments.find_by_text(comment_text).should be_present
end

Then 'there should not be a "$comment_text" comment on "$task_text" task' do |comment_text, task_text|
  task = Task.find_by_text! task_text
  task.comments.find_by_text(comment_text).should_not be_present
end


Then 'I should not be able to edit or delete the "$comment_text" comment' do |comment_text|
  comment = Comment.find_by_text! comment_text

  visit task_path(comment.task)

  with_scope "#comment_#{comment.id}" do
    page.should_not have_content 'Edit'
    page.should_not have_content 'Delete'
  end
end
