Taskar.Comments =
  behaviors:
    'ajax:put':
      '.task .archive': ->
        task = $(this).closest('.task')

        return if task.length is 0

        archived = not task.is('.archived')

        task.toggleClass('archived', archived)
        task.find('.checkbox').attr('data-disabled': archived or null)
        $('#new_comment')["slide#{if archived then 'Up' else 'Down'}"]()

    'ajax:delete':
      '.comment': -> $(this).slideUp 'fast', -> $(this).remove()

    'key:esc':
      'form': Taskar.cancelAction

  actions:
    show: (elementId, html, commentsCount = 1) ->
      console.log "##{elementId}"
      comment = $("##{elementId}")

      unless comment.length is 0
        comment.replaceWith(html)
      else
        Taskar.resetForm('#new_comment')
        $('#comments').show().find('ul').append(html)
        $("##{elementId}").css('display': 'none').slideDown()
        $('#comments_count').html(commentsCount)

    errorOnNew: (html) -> $('#new_comment').replaceWith(html).find('textarea').focus();

    edit: (elementId, html) -> $("##{elementId}").html(html)

    afterDestroy: (commetnsCount) ->
      if commetnsCount is 0
        $('#comments').slideUp('fast')
      else
        $('#comments_count').html(commetnsCount)
