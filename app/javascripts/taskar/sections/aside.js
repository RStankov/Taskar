Taskar.Sections.Aside = function(aside){
  var url = aside.getAttribute('data-update-path');
  
  function updateAside(t){
    var data  = t.responseJSON || {},
        count = $('user_card').down('a');
        
    if (count.innerHTML != data.responsibilities_count){
      count.morph('opacity:0', function(e){
        count.update(data.responsibilities_count || '').morph('opacity:1');
      });
    }
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