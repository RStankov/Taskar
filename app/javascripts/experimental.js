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
Graphics.createPieChart = function(container){
  var seeder  = container.down('ul');
  
  if (!seeder){
    return;
  }
  
  var size    = container.getWidth(),
      holder  = new Element('div'),
      paper   = new Raphael(holder, size, size);
      
  var colors  = container.select('[data-color]').invoke('getAttribute', 'data-color'),
      labels  = container.select('strong').pluck('innerHTML'),
      values	= container.select('em').map(function(element){ return parseInt(element.innerHTML, 10); }).reject(function(v){ return v <= 0; });
  
  if (values.length < 2){
    paper
      .path("M29.124,12.75c-0.004-2.208-1.792-3.997-3.999-4V8.749H12.868c-0.505-1.622-2.011-2.808-3.805-2.811H6.188c-2.208,0.002-3.997,1.792-4.001,4v14.188c0.004,2.206,1.793,3.995,4.001,3.999h18.938c2.205-0.004,3.995-1.793,3.999-3.999V12.75zM6.188,7.937h2.875c1.046-0.004,1.917,0.834,1.983,1.876l0.058,0.937h14.022c1.093,0.002,1.997,0.906,1.999,2v0.495c-0.591-0.345-1.268-0.557-2-0.558H6.187c-0.732,0.001-1.41,0.214-2,0.559V9.937C4.19,8.843,5.094,7.939,6.188,7.937zM25.125,26.125H6.188c-1.093-0.002-1.997-0.908-2.001-2v-7.438h0.001c0.002-1.095,0.906-1.999,2-2.001h18.938c1.093,0.002,1.991,0.901,2,1.991v7.447C27.122,25.219,26.218,26.123,25.125,26.125z")    
      .attr({fill: "#000", stroke: "none"})
      .translate(60, 60)
      .scale(4, 4);
  
    seeder.insert({before: holder})
    seeder.remove();

    return;  
  }

  var center  = size/2
      radius  = size/2.4,
      angle   = 0,
      rad     = Math.PI / 180,
      chart   = paper.set(),
      total   = values.reduce(function(total, value){ return total + value });

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
  
  seeder.insert({before: holder})
  seeder.remove();
};

$$('li.project').each(Graphics.createPieChart);