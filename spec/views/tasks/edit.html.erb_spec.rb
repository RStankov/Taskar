require 'spec_helper'

describe "/tasks/edit.html.erb" do
  before(:each) do
    assigns[:task] = @task = stub_model(Task,
      :new_record? => false,
      :section => 1,
      :text => "value for text",
      :status => 1,
      :position => 1
    )
  end

  it "renders the edit task form" do
    render

    response.should have_tag("form[action=#{task_path(@task)}][method=post]") do
      with_tag('input#task_section[name=?]', "task[section]")
      with_tag('textarea#task_text[name=?]', "task[text]")
      with_tag('input#task_status[name=?]', "task[status]")
      with_tag('input#task_position[name=?]', "task[position]")
    end
  end
end
