Taskar.Sections.Aside = {
  initialize: function(element){
    var url = element.getAttribute("data-update-path");
    Ajax.Responders.register({
      onComplete: function(request){
        var method = request.options.method;
        if (method == "post" || method == "put" || method == "delete"){
          new Ajax.Request(url, { method: "get" })
        }
      }
    });
  },
  updateContent: function(element, newHtml){
    if (element.innerHTML != newHtml){
      element.morph("opacity:0", function(e){
        element.update(newHtml || "").morph("opacity:1");
      });
    }
  },
  updateResponsibilities: function(count){
    this.updateContent($("user_card").down("a"), count);
  },
  updateParticipant: function(element, options){
    element = $(element);
    element.setAttribute("title", options.title || "");
    this.updateContent(element.down('.status'), options.status);
  },
  updateEvents: function(count){
    var badget = $('notify_badge');
    if (!count){
      badget.hide();
    } else {
      badget.update(count).appear();
    }
  }
};