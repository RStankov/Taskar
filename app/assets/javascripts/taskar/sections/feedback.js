Taskar.Sections.Feedback = function(element){
  var appear = Taskar.UI.WindowForm("feedback_form");

  $("feedback_form").observe('ajax:post', function(e) { this.fade(); });

  element.observe("click", function(e){
    e.stop();
    $("feedback_form").setStyle({
      top:  (e.pointerY() +  20) + "px",
      left: (e.pointerX() - 380) + "px"
    });
    appear();
  });
};