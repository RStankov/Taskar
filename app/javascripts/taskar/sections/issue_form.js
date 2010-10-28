Taskar.Sections.IssueForm = function(element){
  var appear = Taskar.UI.WindowForm("feedback_form");
  element.observe("click", function(e){
    e.stop();
    $("feedback_form").setStyle({
      top:  (e.pointerY() +  20) + "px",
      left: (e.pointerX() - 380) + "px"
    });
    appear();
  });
};