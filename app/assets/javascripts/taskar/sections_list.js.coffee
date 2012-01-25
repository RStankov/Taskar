Taskar.SectionsList =
  initialize: ->
    container = $(this)
    newSection = $('#new_section')

    show = (e, element = $(e.target)) ->
      e.preventDefault()

      newSection.find('form')[0].reset()
      newSection.find('input[name*=insert_before]').val(element.data('before'))

      if newSection.is(':visible')
        newSection.slideUp('fast', -> showBefore(element)) unless element.closest('li').prev().attr('id') is 'new_section'
      else
        showBefore(element)

    showBefore = (element) ->
      element.hide().delay(1).fadeIn(0)
      element.parents('li').before(newSection)
      newSection.slideDown 'fast', -> $(this).find(':text').focus()

    showLast = (e) -> show e, container.find('.add_section:last')

    hide = -> newSection.slideUp('fast')

    if container.find('.section').length == 0 and $('#sections_new').length == 0
      showBefore(container.find('.add_section:last'))

    container
      .on('click',   '.add_section',       show)
      .on('click',   'h3 a',               showLast)
      .on('click',   'input[type=button]', hide)
      .on('key:esc', 'form',               hide)
      .on('submit',  'form',               Taskar.validateForm)

    container.find('ul').sortable
      items:  '.section'
      handle: '.drag'
      axis:   'y'
      update: -> $(this).trigger 'order:updated', $(this).sortable('serialize')

  actions:
    show: (titleHtml, descriptionHtml) ->
      $('#section_title').slideUp 'fast', ->
        element = $(this)
        element.html(titleHtml).slideDown('fast')
        if descriptionHtml.length > 0
          element.after $('<p>')
            .addClass('text')
            .attr('id', 'section_text')
            .html(descriptionHtml)
            .hide()
            .slideDown('fast')

    edit: (html) ->
      $('#section_title').slideUp 'fast', -> $(this).html(html).slideDown('fast')
      $("#section_text").slideUp 'fast', -> $(this).remove()