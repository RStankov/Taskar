Taskar.Sections.Aside =
  actions:
    refresh: (options = {}) ->
      aside = Taskar.Sections.Aside
      aside.updateEvents(options.events, options.eventsText);
      aside.updateResponsibilities(options.responsibilities);
      for participant in options.participants or []
        aside.updateParticipant participant.elementId,
          title:  participant.title,
          status: participant.status

  initialize: () ->
    element = $(this)
    element.delegate '#user_card img', 'click', Taskar.showWindowForm('#new_status')

    url = element.data('update-path');
    $(document).ajaxSuccess (e, xhr, options) ->
      $.get(url) if options.type in ['POST', 'PUT', 'DELETE']

  updateContent: (element, newHtml = '') ->
    unless element.html() is newHtml
      element.fadeOut 'fast', ->
        element.html(newHtml).fadeIn('fast')

  updateResponsibilities: (count) ->
    @updateContent $('#user_card a:first'), count

  updateParticipant: (elementId, options) ->
    element = $("##{elementId}")
    element.attr('title', options.title or '')
    @updateContent element.find('.status'), options.status

  updateEvents: (count, title) ->
    badget = $('#notify_badge');
    unless badget.innerHTML is "#{count}"
      unless count
        badget.hide()
      else
        badget.html(count).attr({title}).fadeIn()
