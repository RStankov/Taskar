Taskar.UI.LiveSearch = Class.create({
  initialize: function(options){
    options = Object.extend({
      url:        null,
      method:     'post', 
      input:      null,
      results:    null,
      indicator:  null,
      resultItem: 'li',
      onSelect:   false
    }, options);

    this.url        = options.url;
    this.method     = options.method;
    this.resultsBox = $(options.results).hide();
    this.input      = $(options.input);
    this.resultItem = options.resultItem;

    options.onSelect && (this.onSelect = options.onSelect);

    this.handleKeypress = this.handleKeypress.bind(this);
    this.handleFocusOut = this.handleFocusOut.bind(this);
    this.handleSearch   = this.search.bind(this);

    var indicator = options.indicator && $(options.indicator);
    this.showIndicator = indicator ? Element.show.curry(indicator) : Prototype.emptyFunction;
    this.hideIndicator = indicator ? Element.hide.curry(indicator) : Prototype.emptyFunction;

    this.input.setAttribute('autocomplete', 'off');
    this.input.observe('keypress',  this.handleKeypress);		
    this.input.observe('blur',      this.handleFocusOut);
    this.input.observe('change',    this.handleFocusOut);

    new Form.Element.Observer(this.input, 1.0, this.handleSearch);

    this.resultsBox.on('mouseover', this.resultItem, this.selectItem.bind(this));
    this.resultsBox.on('click',     this.resultItem, this.select.bind(this));
  },
  handleFocusOut:function(){
    Element.hide.delay(.5, this.resultsBox);
  },
  handleKeypress:function(e){
    switch (e.which || e.keyCode) {
      case Event.KEY_ESC:     return this.close();
      case Event.KEY_UP:      return this.updateSelection(-1); 
      case Event.KEY_DOWN:    return this.updateSelection(+1);
      case Event.KEY_RETURN:  return this.select(e);
    }
  },
  close:function(){
    this.input.clear();
    this.resultsBox.hide();
  },
  search:function(){
    var value = this.input.getValue();

    if (value.length < 1 || value == this.input.getAttribute('title')){
      return this.resultsBox.hide();
    }
    
    var params = {};
    params[this.input.name] = value;
    
    this.showIndicator();
    
    new Ajax.Updater(this.resultsBox, this.url, {
      method:     this.method || 'get',
      parameters: params,
      onComplete:	function(){
        this.hideIndicator();
        this.resultsBox.show();
      }.bind(this)
    });
  },
  onSelect: function(item){
    var href = (item.tagName.toLowerCase() == 'a'  ? item : item.down('a')).href;
    href && (window.location = href);
  },
  select: function(e){
    e.stop();

    var selected = this.resultsBox.down('.selected');
    if (selected){
      this.onSelect.call(this, selected);
    } else {
      this.search();
    }
  },
  selectItem: function(e){
    this.resultsBox.select('.selected').invoke('removeClassName', 'selected');
    e.findElement(this.resultItem).addClassName('selected');
  },
  updateSelection:function(diff){
    var selected = this.resultsBox.down('.selected');
    if (selected){
      selected.removeClassName('selected');
      if (diff < 0){
        (selected.previous() || (selected.nextSiblings() || selected).last()).addClassName('selected');
      } else {
        (selected.next() || selected.up().down()).addClassName('selected');
      }
    } else {
      if (diff < 0){
        this.resultsBox.select(this.resultItem).last().addClassName('selected');
      } else {
        this.resultsBox.down(this.resultItem).addClassName('selected');
      }
    }
  },
});

Taskar.UI.LiveSearch.Form = function(form, options){
  form = $(form);
  
  var live = new Taskar.UI.LiveSearch(Object.extend({
    url:        form.getAttribute('action'),
    method:     form.getAttribute('method'),
    input:      form.down('input[type=text]'),
    results:    form.down('ul'),
    indicator:  form.down('img'),
  }, options || {}));
 
  form.observe('submit', function(e){
    e.stop();
    live.search();
  });
};