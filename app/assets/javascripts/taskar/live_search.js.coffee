class Taskar.LiveSearchForm
  constructor: (form) ->
    form = $(form)

    @url          = form.attr('action')
    @indicator    = form.find('img')

    @input = form.find(':input:text')
      .attr('autocomplete', 'off')
      .bind
        'keyup':  @handleKeypress
        'blur':   @handleFocusOut
        'change': @handleFocusOut

    @resultsBox = form.find('ul')
      .hide()
      .delegate 'li',
        'click':      @select
        'mouseover':  @selectItem

    form.submit @search

    new Taskar.LiveSearchForm.InputObserver(@input, 1.0, @search)

  onSelect: (item) ->
    link = if item.is('a') then item else item.find('a').first()
    href = link.attr('href')
    window.location = href if href

  handleFocusOut: => @resultsBox.delay(300).fadeOut(0)

  handleKeypress: (e) =>
    event = $.ui.keyCode
    switch e.keyCode
      when event.ESCAPE then @close()
      when event.UP     then @updateSelection 'up'
      when event.DOWN   then @updateSelection 'down'
      when event.ENTER  then @select(e)

  close: ->
    @input.val('')
    @resultsBox.hide()

  search: =>
    value = @input.val()

    return @resultsBox.hide() unless value.length > 0

    @indicator.show()

    @resultsBox.load "#{@url}?#{@input.attr('name')}=#{value}", =>
      @indicator.hide()
      @resultsBox.show()

    false

  select: (e) =>
    e.preventDefault()

    selected = @resultsBox.find('.selected:first')
    if selected.length > 0
      @onSelect selected
    else
      @search()

  selectItem: (e) =>
    @markSelected $(e.target).closest('li')

  updateSelection: (direction) ->
    selected = @resultsBox.find('li.selected:first')
    results  = @resultsBox.find('li')

    @markSelected if direction is 'up'
      selected.prev('li').add(results.last()).first()
    else
      selected.next('li').add(results.first()).last()

  markSelected: (element) =>
    @resultsBox.find('.selected').removeClass('selected')
    element.addClass('selected')

class Taskar.LiveSearchForm.InputObserver
  constructor: (element, @frequency, @callback) ->
    @element   = $(element)
    @lastValue = @element.val()
    @registerTimer()

  registerTimer: -> @timer = setTimeout @checkForNewValue, @frequency * 1000

  checkForNewValue: =>
    try
      value = @element.val()
      if value isnt @lastValue
        @callback value, @element
        @lastValue = value
      @registerTimer()
    catch error
      @registerTimer()
      throw error