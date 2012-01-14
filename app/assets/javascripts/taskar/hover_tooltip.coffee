Taskar.HoverTooltip = do ->
  class Tooltip
    constructor: (element, @showOn, @hoverOn, e) ->
      @element = $(element)
      @hover   = $()
      @positionate(e) if e?

    positionate: (e) ->
      target = $(e.target)
      if target.find(@showOn).length > 0
        @element.hide()
      else
        @hover target.find(@hoverOn) if @hoverOn?
        @element.css
          display:  'block'
          top:      e.pageY + 20
          left:     e.pageX + 20

      hover: (element) ->
        unless element.is(@hover)
          @hover.removeClass('hover')
          @hover = element.addClass('hover')

      unhover: ->
        @hover.removeClass('hover')
        @hover = $()

      destroy: ->
        @unhover()
        @hover = null
        @element.hide()
        @element = null

  create = (e) ->
    @instance = new Tooltip('info_bubble', 'aside', '.link:not(.selected)', e)
    @move     = move

  move = (e) -> @instance.positionate(e)

  hide = ->
    if @instance
      @instance.destroy
      @instance = null
      @move     = create

  instance: null,
  move:     create
  hide:     hide
