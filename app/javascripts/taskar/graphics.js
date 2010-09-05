Taskar.Graphics = {
  Colors: {
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
  },
  createPieChart: (function(){
    function mouseover(e){
      this.animate({scale: this.paper.overScale}, 500, "elastic");

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
      this.animate({scale: this.paper.outScale}, 500, "elastic");
      $('info_bubble').hide();
    }
  
    function createPieChart(seeder){
      var colors    = seeder.select('[data-color]').invoke('getAttribute', 'data-color'),
          labels    = seeder.select('strong').pluck('innerHTML'),
          values	  = seeder.select('em').map(function(element){ return parseInt(element.innerHTML, 10); }).reject(function(v){ return v <= 0; }),
          total     = values.reduce(function(total, value){ return total + value }),
          size      = seeder.up('li').getWidth(),
          holder    = new Element('div'),
          paper     = new Raphael(holder, size, size),
          center    = size/2
          radius    = size/2.4,
          angle     = 0,
          rad       = Math.PI / 180,
          chart     = paper.set(),
          gradient    = Taskar.Graphics.Colors.buildGradient.bind(Taskar.Graphics.Colors);

      paper.overScale = [1.1, 1.1, center, center];
      paper.outScale  = [1,   1,   center, center];

      chart.push.apply(chart, values.map(function(value, index){
        var start	= angle,
            end		= (angle += 360 * value / total),
            x1		= center + radius * Math.cos(-start  * rad),
            x2		= center + radius * Math.cos(-end    * rad),
            y1		= center + radius * Math.sin(-start  * rad),
            y2		= center + radius * Math.sin(-end    * rad),
            path  = paper.path(["M", center, center, "L", x1, y1, "A", radius, radius, 0, + (end - start > 180), 0, x2, y2, "z"]);
                      
        path.attr({
            "gradient":     gradient("90", colors[index]), 
            "stroke":       "#fff", 
            "stroke-width": 1,
          })
          .hover(mouseover, mouseout)
          .mousemove(mousemove)
          .title = labels[index];
      
        return path;
      }));

      seeder.insert({before: holder})
      seeder.remove();
    };
  
    return createPieChart;
  })()
};