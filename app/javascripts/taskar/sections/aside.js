Taskar.Sections.Aside = function(aside){
  var url = aside.getAttribute('data-update-path');
  
  function updateAside(t){
    var data = t.responseJSON || {};
    
    $('user_card').down('span').update(data.responsibilities_count || 0);
  }
  
  Ajax.Responders.register({
    onComplete: function(request){
      var method = request.options.method;
      if (method == 'post' || method == 'put' || method == 'delete'){
        new Ajax.Request(url, {
          method: 'get',
          onComplete: updateAside
        })
      }
    }
  });
}