module TitleHelper
  def title(text)
    @_title ||= text
    text
  end

  def title_name(base_title)
    if @_title.present?
      "#{@_title} | #{base_title}"
    else
      base_title
    end
  end
end