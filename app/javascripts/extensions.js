Element.addMethods({
  hideForASecond: function(element){
    element = $(element);
    element.hide();
    element.show.bind(element).defer();
    return element;
  },
  effect: function(element, effect, options){
    if (Object.isFunction(effect))
      effect = new effect(element, options);
    else if (Object.isString(effect))
      effect = new S2.FX[effect.charAt(0).toUpperCase() + effect.substring(1)](element, options);
    effect.play(element, options);
    return element;
  },
  removeWithEffect: function(element, effect, options){
		options = S2.FX.parseOptions(options);
		options.after = options.after ?
		  options.after.wrap(function(callback,e){ callback(e); Element.remove(e.element); }) : function(e){ Element.remove(e.element); };

		return $(element).effect(effect, options);
	},
	replaceWithEffect: function(element, content){
		element = $(element);
		element.morph({
			change: function(){
	    	element.replace(content);
			}
		});
		return element;
	},
	transform: function(element, content){
		element = $(element);
		element.morph({
			change: function(){
	    	element.update(content);
			},
			after: function(){
	    	element.highlight();
				var textarea = element.down("textarea");
				textarea && textarea.focus();
			}
		});
		return element;
	}
});
