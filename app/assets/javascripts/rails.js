(function(){
  Ajax.Responders.register({
    onCreate: function(request) {
      var csrf_meta_tag = $$('meta[name=csrf-token]')[0];

      if (csrf_meta_tag) {
        var header = 'X-CSRF-Token',
            token = csrf_meta_tag.readAttribute('content');

        if (!request.options.requestHeaders) {
          request.options.requestHeaders = {};
        }
        request.options.requestHeaders[header] = token;
      }
    }
  });

  document.on('click', 'a[data-method]', function(e, element){
  	if (element.hasAttribute('data-remote')) return;

  	e.stop();

  	if (!element.hasAttribute('data-confirm') || confirm(element.getAttribute('data-confirm'))){
  		var method  = element.getAttribute('data-method');
  		    form    = Element('form', {method: 'post', action: element.href}).hide()
  		    param   = $$('meta[name=csrf-param]')[0],
          token   = $$('meta[name=csrf-token]')[0];

  		if (param && token){
  		  form.insert(Element('input', {type: 'hidden', name: param.readAttribute('content'), value: token.readAttribute('content')}));
		  }

      if (method != 'post'){
        form.insert(Element('input', {type: 'hidden', name: '_method', value: method}))
      }

  		element.insert({after: form});

  		form.submit();
  	}
  });

  function handleRemote(e, element){
    if (!e.stopped){
      e.stop();
      if (!element.fire('ajax:before').stopped){
        var request = element.request();
        element.fire('ajax:' + request.options.method);
        element.fire('ajax:after');
      }
    }
  }

  document.on('click', 'a[data-remote=true]', handleRemote);
  document.on('submit', 'form[data-remote=true]', handleRemote);

  document.observe('keyup', function(e){
    if (e.keyCode == Event.KEY_ESC){
      e.findElement().fire('key:esc');
    }
  });
})();