module TaskarMocks
  def mock_account(stubs={})
    @mock_account ||= mock_model(Account, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, {:account => mock_account}.merge(stubs))
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  def mock_section(stubs={})
    @mock_section ||= mock_model(Section, {:project => mock_project}.merge(stubs))
  end
  
  def mock_task(stubs={})
    @mock_task ||= mock_model(Task, {:section => mock_section, :project => mock_project, :user => mock_user}.merge(stubs))
  end
  
  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, {:task => mock_task, :user => mock_user, :project => mock_project}.merge(stubs))
  end
  
  def mock_event(stubs={})
    @mock_event ||= mock_model(Event, stubs)
  end
  
  def mock_status(stubs={})
    @mock_status ||= mock_status(Status, stubs)
  end
end