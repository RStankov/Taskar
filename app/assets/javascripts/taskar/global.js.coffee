Taskar.GlobalBehaviors =
  'ajax:after':
    '.action_form': ->
      element = $(this)
      if element.data('disable') isnt 'false'
        element.addClass('loading')
        element.find(':input').prop('disable', true)

    '.edit': ->
      $(this)
        .addClass('loading')
        .css('text-decoration': 'none')
        .html(@innerHTML.replace(/./g, '.'))

  'ajax:delete':
    '#statuses_list': -> $('li', this).slideUp 'fast', -> $(this).remove()

  'order:updated':
    '[data-sortable-url]': (e, data) ->
      $.ajax
        url:  $(this).data('sortable-url')
        type: 'put'
        data: data

  'click':
    '.flash': -> $(this).slideUp 'fast', -> $(this).remove()

    '#scroll_to_top': -> window.scrollTo 0, 0

    '.checkbox[data-disabled!=true]': do ->
      STATES =
        'opened':     'completed'
        'completed':  'rejected'
        'rejected':   'opened'

      changeState = (element) ->
        current = element.data('state')
        next    = STATES[current] or 'opened'

        element.data('state', next)
        element.parents('.task').andSelf().removeClass(current).addClass(next)

      clearTimer = (element) ->
        timer = element.data('state:timer')
        if timer?
          clearTimeout timer
          element.removeData 'state:timer'

      setTimer = (element) ->
        element.data 'state:timer', setTimeout ->
          element.removeData 'state:timer'
          $.ajax
            url:  element.data('url')
            type: 'put'
            data: {state: element.data('state')}
        , 500

      (e) ->
        element = $(this)
        clearTimer element
        changeState element
        setTimer element

