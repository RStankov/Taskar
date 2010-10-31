class ChangelogController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :set_locale

  before_filter :set_locale_from_param

  def index
  end
end
