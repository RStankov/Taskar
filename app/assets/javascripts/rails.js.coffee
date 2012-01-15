do (jQuery) ->
  $ = jQuery
  $.ajaxPrefilter (options, originalOptions, xhr) ->
    unless options.crossDomain
      token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token) if token?

  handleMethod = (e) ->
    link = $(this)
    confirmMessage = link.data('confirm')

    return false if confirmMessage? and not confirm(confirmMessage)

    token = $('meta[name="csrf-token"]').attr('content')
    param = $('meta[name="csrf-param"]').attr('content')

    html  = '<input name="_method" value="' + link.data('method') + '" type="hidden" />'
    html += '<input name="' + param + '" value="' + token + '" type="hidden" />' if param? and token?

    $('<form method="post" action="' + link.attr('href') + '"></form>')
      .hide()
      .html(html)
      .appendTo('body')
      .submit()

    false

  fireEvent = (object, name, data) ->
    event = $.Event(name)
    object.trigger(event, data)
    event.result isnt false

  handleRemote = (e) ->
    e.preventDefault()

    element = $(this)

    confirmMessage = element.data('confirm')

    return false if confirmMessage? and not confirm(confirmMessage)
    return false if e.result is false or not fireEvent(element, 'ajax:before')

    [method, url, data] = if element.is('form')
      [element.attr('method'), element.attr('action'), element.serializeArray()]
    else
      [element.data('method'), element.attr('href')]

    $.ajax
      url:        url
      type:       method or 'GET'
      data:       data
      dataType:   element.data('type') or 'script'
      beforeSend: (xhr, settings) -> xhr.setRequestHeader 'accept', '*/*;q=0.5, ' + settings.accepts.script if settings.dataType?

    element.trigger('ajax:' + method);
    element.trigger('ajax:after');

    false

  handleKey = (e) ->
    if e.keyCode is 27 then $(e.target).trigger('key:esc')

  $(document)
    .delegate('a[data-method]:not([data-remote])', 'click', handleMethod)
    .delegate('a[data-remote]', 'click', handleRemote)
    .delegate('form[data-remote]', 'submit', handleRemote)
    .bind('keyup', handleKey)
