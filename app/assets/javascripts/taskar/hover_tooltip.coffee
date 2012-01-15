class Taskar.HoverTooltip
  constructor: (element, @showOn, @hoverOn) ->
    @element = $(element).hide()
    @hovered = $()

  positionate: (e) =>
    target = $(e.target)
    if target.closest(@showOn).length == 0
      @element.hide()
    else
      @hover target.closest(@hoverOn).first()
      @element.css
        display:  'block'
        top:      e.pageY + 20
        left:     e.pageX + 20

  hover: (element) ->
    unless element.is @hovered
      @hovered.removeClass('hover')
      @hovered = element.addClass('hover')

  unhover: ->
    @hovered.removeClass('hover')
    @hovered = $()

  hide: ->
    @unhover()
    @element.hide()

  start: ->
    $(document).bind('mousemove', @positionate)

  stopAndReturn: ->
    droppedOn = @hovered
    $(document).unbind('mousemove', @positionate)
    @hide()
    droppedOn