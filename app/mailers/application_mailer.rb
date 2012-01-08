class ApplicationMailer < ActionMailer::Base
  prepend_view_path Rails.root.join("app", "views", "mailers")

  default :from => 'Taskar Team <support@example.org>'
  default_url_options[:host] = 'example.org'
end
