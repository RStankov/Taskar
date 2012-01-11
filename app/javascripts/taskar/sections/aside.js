Taskar.Sections.Aside = {
  actions: {
    refresh: function(options) {
      options || (options = {});

      var aside = Taskar.Sections.Aside;

      aside.updateEvents(options.events, options.eventsText);
      aside.updateResponsibilities(options.responsibilities);

      if (options.participants) {
        options.participants.each(function(participant) {
          aside.updateParticipant(participant.elementId, {
            title:  participant.title,
            status: participant.status
          });
        });
      }
    }
  },
  initialize: function(element) {
    var url = element.getAttribute("data-update-path");
    Ajax.Responders.register({
      onComplete: function(request) {
        var method = request.options.method;
        if (method == "post" || method == "put" || method == "delete") {
          new Ajax.Request(url, { method: "get" });
        }
      }
    });
  },
  newStatusForm: function(userCard) {
    userCard.down("img").observe("click", Taskar.UI.WindowForm("new_status"));
  },
  updateContent: function(element, newHtml) {
    if (element.innerHTML != newHtml) {
      element.morph("opacity:0", function(e) {
        element.update(newHtml || "").morph("opacity:1");
      });
    }
  },
  updateResponsibilities: function(count) {
    this.updateContent($("user_card").down("a"), count);
  },
  updateParticipant: function(element, options) {
    element = $(element);
    if (element) {
      element.setAttribute("title", options.title || "");
      this.updateContent(element.down('.status'), options.status);
    }
  },
  updateEvents: function(count, title) {
    var badget = $('notify_badge');
    if (badget.innerHTML != count) {
      if (!count) {
        badget.hide();
      } else {
        badget.update(count).writeAttribute("title", title).appear();
      }
    }
  }
};