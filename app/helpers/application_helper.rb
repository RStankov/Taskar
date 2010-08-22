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
  
  def title(page_title)
    page_title = t(page_title, :default => page_title)
    content_for :title, page_title
    "<h1>#{page_title}</h1>"
  end
  
  def javascript_response(&block)
    concat("try {" + capture(&block) + "} catch(e){ alert(e); }")
  end
  
  def copywrite
    t(:'copywrite', :year => Time.now.year)
  end
  
  def time_tag(time)
    '<time datetime="' + time.rfc2822  + '" title="' + l(time, :format => :long) + '">' + t(:before, :time => time_ago_in_words(time)) + '</time>'
  end
  
  def csrf_meta_tag
    if protect_against_forgery?
      %(<meta name="csrf-param" content="#{h(request_forgery_protection_token)}"/>\n<meta name="csrf-token" content="#{h(form_authenticity_token)}"/>)
    end
  end
  
  def insert_at(content = nil)
    <<-TOOL_TIP
    <div class="insert_at">
      #{content}
      <div class="pointer"></div>
    </div>
		TOOL_TIP
  end
end
