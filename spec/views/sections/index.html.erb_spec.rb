require 'spec_helper'

describe "/sections/index.html.erb" do
  before do
    assign :events,  [ Factory(:event) ].paginate
    assign :project, mock_project
  end

  it { render }
end
