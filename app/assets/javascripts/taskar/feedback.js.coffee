Taskar.Feedback = ->
  form   = $('#feedback_form')
  appear = Taskar.showWindowForm(form)

  $(this).click (e) ->
    form.css
      top:  e.pageY + 20
      left: e.pageX - 380

    appear()
    false
