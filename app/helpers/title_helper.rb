module TitleHelper
  def title(text)
    @_title ||= []
    @_title << text
    text
  end

  def title_value(default)
    @_title ||= [default]
    @_title.reverse.join ': '
  end
end