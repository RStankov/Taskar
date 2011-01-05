var CD3 = {};

/*
 * based on:
 *    Justin Palmer's EventSelectors (http://encytemedia.com/event-selectors)
 *    Dan Webb's LowPro (http://svn.danwebb.net/external/lowpro)
 */

CD3.Behaviors = (function(){
	function run(args){
		if (args.length == 1){
			var root = document, rules = args[0];
		} else {
			var root = $$(args[0]).first(), rules = args[1];
		}

		if (root) assign(root, Object.isFunction(rules) ? rules.call(root, root) : rules);
	}

	function assign(root, rules){
		for (var selector in rules){
			var observer = rules[selector], parts = selector.split(':'), css = parts.shift(), event = parts.join(':');
			Selector.findChildElements(root, [css]).each(function(element){
				if (event){
					observe(element, event, observer);
				} else if (observer.prototype && observer.prototype.initialize){
					new observer(element);
				} else if (Object.isFunction(observer)){
					observer.call(element, element);
				} else if (Object.isArray(observer)){
					var klass = observer.shift();
					new klass(element, observer.shift());
				} else {
					for(var e in observer) observe(element, e, observer[e]);
				}
			});
		}
	}

	function observe(element, event, observer){
		if (Object.isFunction(observer)){
			Event.observe(element, event, observer);
		} else {
			for(var selector in observer){
			  Event.on(element, event, selector, observer[selector]);
			}
		}
	}

	return function(){
		if (document.loaded){
			run(arguments);
		} else {
			document.observe('dom:loaded', run.curry(arguments));
		}
	};
})();

Element.addMethods({
	extractId:  function(element){
		return (element.id && element.id.match(/\w+_(\d+)/)[1]) || 0;
	},
	unsetStorage: function(element){
		if (!(element = $(element))) return;

		if (element === window){
			delete(Element.Storage[0]);
		} else if (typeof element._prototypeUID !== "undefined") {
			var uid = element._prototypeUID[0];
			if (uid in Element.Storage)
				delete(Element.Storage[uid]);
		}
		return element;
	},
	replaceClassName: function(element, oldClassName, newClassName){
     element = $(element);
     element.className = element.className.replace(oldClassName, newClassName);
     return element;
   }
});

Element.addMethods('A', {
	request: function(element, options){
		element = $(element);

		if (element.hasAttribute('data-confirm') && !confirm(element.getAttribute('data-confirm'))){
			return element;
		}

		options = Object.extend({
		  method:       element.getAttribute('data-method') || 'get',
		  parameters:   {},
  	  evalScripts:  true
		}, options || {});

		if (element.hasAttribute('data-update')){
			return new Ajax.Updater(element.getAttribute('data-update'), element.readAttribute('href'), options);
		}

		return new Ajax.Request(element.readAttribute('href'), options);
	}
});
Element._insertionTranslations.into = function(element, node){
	node.appendChild(element);
};

Element._insertionTranslations.instead = function(element, node){
	node.parentNode.replaceChild(element, node);
};

Element.addMethods({
    insert: Element.insert.wrap(function(insert, element, insertation){
        if (!Object.isArray(insertation)) return insert(element, insertation);

        element = $(element);
        insertation.each(insert.curry(element));
        return element;
    })
});
S2.FX.Fade = Class.create(S2.FX.Element, {
	setup: function() {
		this.animate('style', this.element, {style: 'opacity:0'});
	},
	teardown: function() {
		this.element.hide();
	}
});

S2.FX.Appear = Class.create(S2.FX.Element, {
	setup: function() {
		this.animate('style', this.element.setOpacity(0).show(), {style: 'opacity:1'});
	}
});

S2.FX.Highlight = Class.create(S2.FX.Element, {
  initialize: function($super, element, options){
    $super(element, Object.extend({
      startColor: 			  '#ffff99',
      endColor:				      false,
      restoreColor:			    true,
      keepBackgroundImage:	false
    }, options));
  },
  setup: function(){
    if (this.element.getStyle('display') == 'none'){
      return this.cancel();
    }

    if (!this.options.endColor){
      this.options.endColor = this.element.getStyle('background-color');
    }

    if (this.options.restoreColor){
      this.options.restoreColor	= this.element.style.backgroundColor;
    }

    if (this.options.keepBackgroundImage){
      this.restoreBackgroundImage = this.element.getStyle('background-image');
      this.element.style.backgroundImage = 'none';
    }

    this.element.style.backgroundColor = this.options.startColor;
    this.animate("style", this.element, { style: "background-color: " + this.options.endColor});
  },
  teardown: function(){
    this.element.style.backgroundColor = this.options.restoreColor;
    if (this.options.keepBackgroundImage){
      this.element.style.backgroundImage = this.restoreBackgroundImage;
    }
  }
});

Element.addMethods(['slideDown', 'slideUp', 'highlight', 'appear', 'fade'].inject({}, function(methods, effect){
  var name = effect.charAt(0).toUpperCase() + effect.substring(1);
  methods[effect] = function(element, options){
    element = $(element);
    new S2.FX[name](element, options).play();
    return element;
  };
  return methods;
}));

Element.addMethods({
	toggleWithEffect: (function(){
		var PAIRS = {
			'fade':  ['Fade', 'Appear'],
			'slide': ['SlideUp', 'SlideDown']
		};
		return function(element, effect, options){
			element = $(element);

			new S2.FX[(PAIRS[effect] || PAIRS['fade'])[element.visible() ? 0 : 1]](element, options).play();
			return element;
		}
	})()
});