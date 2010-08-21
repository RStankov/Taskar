Taskar.UI.InfoBubble = {
  move: function(e){
    var bubble = $('info_bubble');
    if (e.findElement('aside')){
      bubble.show().setStyle({
        top: e.pointerY() + 20 + 'px',
        left: e.pointerX() + 'px'
      });
    } else {
      bubble.hide();
    }
  },
  hide: function(e){
    $('info_bubble').hide();
  }
}