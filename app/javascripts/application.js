//= require <prototype>
//= require <s2>

var CD3 = {};

//= require <cd3/behaviors>
//= require <cd3/extensions>

//= require "extensions"
//= require "rails"
//= require "taskar"
//= require "behaviors"

Taskar.UI.StateCheckboxObserver();

//= require <raphael-min>
var Graphics = {};

Graphics.Colors = {
	gradients: {
		green: 	['#88bb00', '#c9ff00'],
		yellow: ['#fffc00', '#ffa200'],
		red: 	  ['#f70000', '#b71200'],
		blue: 	['#3fcbff', '#2671e6']
	},
	buildGradient: function(angle, color){
	  var mask = this.gradients[color];
	  return angle + "-" + mask[0] + "-" + mask[1];
	}
};
Graphics.createPieChart = function(dataSeeder){
  var holder  = new Element('div'),
      colors  = dataSeeder.select('[data-color]').invoke('getAttribute', 'data-color'),
      labels  = dataSeeder.select('strong').pluck('innerHTML'),
      values	= dataSeeder.select('em').map(function(element){ return parseInt(element.innerHTML, 10); }).reject(function(v){ return v <= 0; }),
      size    = dataSeeder.getWidth();

  if (values.length < 2){
    return;
  }
  
  var center = size/2
      radius = size/2.4,
      angle  = 0,
      rad    = Math.PI / 180,
      paper  = new Raphael(holder, size, size),
      chart  = paper.set(),
      total  = values.reduce(function(total, value){ return total + value });

  function mouseover(e){
    this.animate({scale: [1.1, 1.1, center, center]}, 500, "elastic");
    
    $('info_bubble').update(this.title).setStyle({
      top:  Event.pointerY(e) + 20 + 'px',
      left: Event.pointerX(e) + 10 + 'px'
    }).show();
  }
  
  function mousemove(e){
     $('info_bubble').setStyle({
        top:  Event.pointerY(e) + 20 + 'px',
        left: Event.pointerX(e) + 10 + 'px'
      });
  }

  function mouseout(){
    this.animate({scale: [1, 1, center, center]}, 500, "elastic");
    $('info_bubble').hide();
  }

  chart.push.apply(chart, values.map(function(value, index){
    var start	= angle,
        end		= (angle += 360 * value / total),
        x1		= center + radius * Math.cos(-start  * rad),
        x2		= center + radius * Math.cos(-end    * rad),
        y1		= center + radius * Math.sin(-start  * rad),
        y2		= center + radius * Math.sin(-end    * rad),
        path  = paper.path(["M", center, center, "L", x1, y1, "A", radius, radius, 0, + (end - start > 180), 0, x2, y2, "z"])
                  .attr({
                    "gradient":     Graphics.Colors.buildGradient("90", colors[index]), 
                    "stroke":       "#fff", 
                    "stroke-width": 1
                  })
                  .mouseover(mouseover)
                  .mousemove(mousemove)
                  .mouseout(mouseout);

    path.title = labels[index];
      
    return path;
  }));
  
  dataSeeder.insert({before: holder})
  dataSeeder.remove();
};

$$('li.project ul').each(Graphics.createPieChart);
