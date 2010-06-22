module ControllerMacros
  def ensure_deny_access_is_called
    def controller.deny_access
      _deny_access_called_
      redirect_to root_path
    end
    
    controller.should_receive(:_deny_access_called_)
  end
end