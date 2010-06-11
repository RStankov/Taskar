//= require <prototype>
//= require <s2>

var CD3 = {};

//= require <cd3/behaviors>
//= require <cd3/extensions>

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

//= require "taskar"
//= require "behaviors"