module ApplicationHelper
  def link_to_delete(*args, &block)
    html_options = ((block_given? ? args.second : args.third) || {}).stringify_keys.merge({
      'data-method' => 'delete'
    });

    html_options['data-confirm'] = html_options.delete('confirm') if html_options['confirm']
    html_options['data-confirm'] = t(:confirm) if html_options['data-confirm'] == true

    if block_given?
      link_to( args.first, html_options, &block )
    else
      link_to( args.first, args.second, html_options )
    end
  end

  def nl2br(text)
    text.gsub!(/\r\n?/, "\n")  # \r\n and \r -> \n
    text.gsub!(/\n/, '<br />') # 1 newline   -> br
    raw text
  end

  def format_text(text)
    nl2br auto_link(h(text))
  end

  def title(page_title)
    page_title = t(page_title, :default => page_title)
    content_for :title, page_title
    raw "<h1>#{page_title}</h1>"
  end

  def javascript_response(&block)
    raw "try {" + capture(&block) + "} catch(e){ alert(e); }"
  end

  def javascript_string_from_partial(partial, options = {})
    raw '"' + escape_javascript(render(partial, options)) + '"'
  end

  def javascript_call_on(object, *args)
    js_args = args.map do |value|
      if value.is_a? Numeric
        value
      else
        '"' + escape_javascript(value) + '"'
      end
    end

    raw "try { #{object}(#{js_args.join(', ')}); } catch(e){ alert(e); }"
  end

  def copywrite
    t(:'copywrite', :year => Time.now.year)
  end

  def time_tag(time)
    raw %(<time datetime="#{time.rfc2822}" title="#{l(time, :format => :long)}">#{t(:before, :time => time_ago_in_words(time))}</time>)
  end

  def insert_at(content = nil)
    raw %(<div class="insert_at">
      #{content}
      <div class="pointer"></div>
    </div>)
  end

  def header(&block)
    if block_given?
      content_for :header, &block
    end
    render "shared/header"
  end
end
