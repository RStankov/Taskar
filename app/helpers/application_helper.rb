module ApplicationHelper
  def link_to_delete(*args, &block)
    html_options = ((block_given? ? args.second : args.third) || {}).stringify_keys.merge({
      'data-method' => 'delete',
      'data-token'  => form_authenticity_token
    });
    
    html_options['data-confirm'] = html_options.delete('confirm') if html_options['confirm']
    html_options['data-confirm'] = t(:confirm) if html_options['data-confirm'] == true
    
    if block_given?
      link_to( args.first, html_options, &block )
    else
      link_to( args.first, args.second, html_options )
    end
  end
  
  def javascript_response(&block)
    concat("try {" + capture(&block) + "} catch(e){ alert(e); }")
  end
  
  def copywrite
    t(:'copywrite', :year => Time.now.year)
  end
  
  def time_tag(time)
    '<time datetime="' + time.rfc2822  + '" title="' + l(time, :format => :long) + '">' + time_ago_in_words(time) + '</time>'
  end
end
