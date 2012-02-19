module SpecSupport
  module Mocks
    def mock_user(stubs={})
      @mock_user ||= mock_model(User, {:account => mock_model(Account)}.merge(stubs))
    end

    def mock_project(stubs={})
      @mock_project ||= mock_model(Project, stubs)
    end

    def mock_project_user(stubs={})
      @mock_project_user ||= mock_model(ProjectUser, {:project => mock_project, :user => mock_user}.merge(stubs))
    end

    def mock_section(stubs={})
      @mock_section ||= mock_model(Section, {:project => mock_project}.merge(stubs))
    end

    def mock_task(stubs={})
      @mock_task ||= mock_model(Task, {:section => mock_section, :project => mock_project, :user => mock_user}.merge(stubs))
    end
  end
end