(function(){  
  document.on('click', 'a[data-method=delete]', function(e, element){
  	if (element.hasAttribute('data-remote')) return;

  	e.stop();

  	if (!element.hasAttribute('data-confirm') || confirm(element.getAttribute('data-confirm'))){
  		var form = Element('form', {method: 'post', action: element.href}).hide()
  			.insert(Element('input', {type: 'hidden', name: '_method', value: 'delete'}))
  			.insert(Element('input', {type: 'hidden', name: 'authenticity_token', value: element.getAttribute('data-token')}));

  		element.insert({after: form});

  		form.submit();
  	}
  });
  
  function handleRemote(e, element){
    if (!e.stopped){
      e.stop();
      element.request();
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