//= require <raphael-min>

Taskar.drawIcon = (function(){
  var PATHS = {
        comments: "M15.985,5.972c-7.563,0-13.695,4.077-13.695,9.106c0,2.877,2.013,5.44,5.147,7.108c-0.446,1.479-1.336,3.117-3.056,4.566c0,0,4.015-0.266,6.851-3.143c0.163,0.04,0.332,0.07,0.497,0.107c-0.155-0.462-0.246-0.943-0.246-1.443c0-3.393,3.776-6.05,8.599-6.05c3.464,0,6.379,1.376,7.751,3.406c1.168-1.34,1.847-2.892,1.847-4.552C29.68,10.049,23.548,5.972,15.985,5.972zM27.68,22.274c0-2.79-3.401-5.053-7.599-5.053c-4.196,0-7.599,2.263-7.599,5.053c0,2.791,3.403,5.053,7.599,5.053c0.929,0,1.814-0.116,2.637-0.319c1.573,1.597,3.801,1.744,3.801,1.744c-0.954-0.804-1.447-1.713-1.695-2.534C26.562,25.293,27.68,23.871,27.68,22.274z",
        comment:  "M16,5.333c-7.732,0-14,4.701-14,10.5c0,1.982,0.741,3.833,2.016,5.414L2,25.667l5.613-1.441c2.339,1.317,5.237,2.107,8.387,2.107c7.732,0,14-4.701,14-10.5C30,10.034,23.732,5.333,16,5.333z"
      },
      DEFAULTS = {
        width:  32,
        height: 32,
        fill:   "#333"        
      };
  return function(e){
    var path = Raphael(e, e.getAttribute("width") || DEFAULTS.width, e.getAttribute("height") || DEFAULTS.height).path(PATHS[e.getAttribute("name")]);
    
    path.attr({fill: e.getAttribute("fill") || "#333", stroke: "none"});
    
    var scale = e.getAttribute('scale');
    if (scale){
      path.scale(scale, scale);
    }
  };
})();


(function(){
  var icons = document.getElementsByTagName('icon');
  for(var i = icons.length - 1; i >= 0; i--){
    Taskar.drawIcon(icons[i]);
  }
})();