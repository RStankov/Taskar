Taskar.TaskList =
  initialize: ->
    element = $(this)

    if element.find('.task').length == 0
      $('#new_task').show().find(':text').focus()

    $('sectionTitle')
      .mouseenter -> $(this).find('a.archive').toggle element.find('.task').length == 0
      .mouseenter()

    tooltip = new Taskar.HoverTooltip('#info_bubble', 'aside', '.link:not(.selected)')

    $('#tasks').sortable
      items:  '.task'
      handle: '.drag'
      axis:   'y'
      update: -> $(this).trigger 'order:updated', $(this).sortable('serialize')
      start:  (e) ->
        $(e.target).addClass('dragging')
        tooltip.start()
      stop:   (e, ui) ->
        $(e.target).removeClass('dragging')
        droppedOn = tooltip.stopAndReturn().closest('.section')
        if droppedOn.length
          $.ajax
            url:  ui.item.data('change-section')
            type: 'put'
            data: {section_id: droppedOn.attr('id').match(/\w+_(\d+)/)[1]}
          ui.item.remove()

  behaviors:
    'click':
      'input.cancel': -> $(this).closest('li').slideUp()

      '.add': (e) ->
        e.preventDefault()
        element = $(this)
        element.hide().delay(1).fadeIn(0)

        insertBefore = ->
          before = element.data('after')

          if before?
            task.after(newTask)
          else
            $('#tasks').append(newTask)

          Taskar.resetNewTaskForm(before, true)
          newTask.slideDown -> newTask.find(':text').focus()

        newTask = $('#new_task')
        task = element.closest('.task')

        if not newTask.is(':visible')
          insertBefore()
        else if task.next()[0] is newTask[0]
          newTask.find(':text').focus()
        else
          newTask.slideUp 'fast', insertBefore

      '.toggle_archived': (e) ->
        e.preventDefault()
        element = $(this)

        archive = $('#archived_tasks')
        if archive.length
          archive
            .toggleClass('selected')
            .slideToggle 'fast', -> Taskar.scrollTo(archive) if archive.is(':visible')
          return

        element.addClass('loading')

        $.get element.data('url'), (html) ->
          element.removeClass('loading')
          element.addClass('selected')
          element.closest('footer').after(html)
          $('#archived_tasks').hide().slideDown 'fast', -> Taskar.scrollTo this

    'ajax:post':
      '#new_task': -> Taskar.resetNewTaskForm()

    'ajax:put':
      '.archive': (e) ->
        e.preventDefault()

        task = $(this).closest('.task')
        task.slideUp 'fast', ->
          [parent, insert, disabled] = if task.parents('#tasks').length
            [$('#archived_tasks'), 'prepend', true]
          else
            [$('#tasks'), 'append', null]

          task.find('.checkbox').attr('data-disabled', disabled)

          if parent.length == 0
            task.remove()
          else
            parent[insert](task)
            task.slideDown('fast')

          task.trigger('task:archive_changed')

    'ajax:delete':
      '.task': -> $(this).slideUp 'fast', -> $(this).remove()

    'key:esc':
      '.task, #section_title form': Taskar.cancelAction

      '#new_task': -> $(this).closest('li').slideUp()

    'task:archive_changed': -> $('#archived_tasks_empty').toggle $('#archived_tasks li').length is 1

  actions:
    errorOnNew: (html) ->
      $('#new_task').replaceWith(html)
      $('#new_task').show().find(':text').focus()

    create: (taskId, taskHtml, higherTaskId) ->
      higher = higherTaskId and $("task_#{higherTaskId}")
      unless higher?.length
        $('#new_task').before taskHtml
      else
        higher.after taskHtml

      $("task_#{taskId}")
        .hide()
        .slideDown -> Taskar.scrollTo this

      Taskar.resetNewTaskForm(taskId)

    edit: (elementId, html) ->
      $("##{elementId}").html(html)

    show: (elementId, inListHtml, inShowActionHtml) ->
      $("##{elementId}").replaceWith if $('#task_title').length then inShowActionHtml else inListHtml
