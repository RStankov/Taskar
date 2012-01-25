#= require_self
#= require taskar/live_search
#= require taskar/hover_tooltip
#= require taskar/global
#= require taskar/comments
#= require taskar/feedback
#= require taskar/aside
#= require taskar/sections_list
#= require taskar/tasks_list

window.Taskar =
  behaviors: (behaviorDefinitions) ->
    for own selector, behaviors of behaviorDefinitions
      if typeof behaviors is 'function'
        $(selector).each behaviors
      else
        for own eventName, actions of behaviors
          if typeof actions is 'function'
            $(selector).bind eventName, actions
          else
            for own matchSelector, action of actions
              $(selector).delegate matchSelector, eventName, action

  validateForm: (e) ->
    valid = true
    $(e.target).closest('form').find('input[type="text"],textarea').each ->
      input = $(this)
      if input.val().length == 0
        valid = false
        input.css backgroundColor:  null
        input.focus()
    valid

  resetNewTaskForm: (before = null, dontPersistResponsible = false) ->
    form          = $('#new_task form')
    resposible    = form.find('select[name*=responsible_party_id]')
    previousValue = resposible.val()

    @resetForm(form)

    resposible.val(previousValue) unless dontPersistResponsible

    form.find('input[name*=insert_after]').val(before) if before isnt false
    form.find('textarea').focus() if form.is(':visible')

  resetForm: (form) ->
    form = $(form)
    form[0].reset()
    form.removeClass 'loading'
    form.find(':input').prop 'enable', true
    form.find('.error_messages').remove()
    form.find('.field_with_errors').each -> $(this).replaceWith @innerHTML

  cancelAction: -> $('.cancel', this).trigger 'click'

  scrollTo: (element) -> window.scrollTo 0, $(element).offset().y

  showWindowForm: (form) ->
    form = $(form)
    html = form.html()

    hideOnOutside = (e) ->
      hide() if $(e.target).parents().index(form) is -1

    hide = ->
      form.fadeOut 'fast'
      $(document).unbind 'click', hideOnOutside

    show =

    form.bind
      'submit':     Taskar.validateForm,
      'key:esc':    hide,
      'ajax:post':  hide

    form.delegate ':button', 'click', hide

    ->
      form.html(html)
      form.fadeIn 'fast', ->
        form.find(':text').focus()
        $(document).bind 'click', hideOnOutside
