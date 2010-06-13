module ApplicationHelper
  def link_to_delete(*args, &block)
    html_options = ((block_given? ? args.second : args.third) || {}).stringify_keys.merge({
      'data-method' => 'delete',
      'data-token'  => form_authenticity_token
    });
    
    html_options['data-confirm'] = html_options.delete('confirm') if html_options['confirm']
    
    if block_given?
      link_to( args.first, html_options, &block )
    else
      link_to( args.first, args.second, html_options )
    end
  end
  
  def javascript_response(&block)
    concat("try {" + capture(&block) + "} catch(e){ if (console) console.log(e); }")
  end
end
