var arrayWordCloud = function (array) {
  // console.log(workarray)
  html = ""
  data = []
  $.each(array, function (i) {
    var obj = {text: array[i][0], size: array[i][1]}
    data.push(obj)
  })

  data.sort(function(a,b) {
    return (a.text > b.text) ? 1 : ((b.text > a.text) ? -1 : 0);} );

  max = Math.max.apply(Math,data.map(function(o){return o.size;}))
  min = Math.min.apply(Math,data.map(function(o){return o.size;}))

  $.each(data, function (i) {
    size = data[i]['size']
    html += '<span style="color:'+colorizeFont(data[i]['size'],[min,max])+
      '; font-size:'+scaleFont(data[i]['size'],[min,max])+'em;">'+
    // html += '<span style="font-size:'+scaleFont(data[i]['size'],[min,max])+'em;">'+
      data[i]['text']+'</span> '
  })
  return html;
}

var histYears = function (years) {
  // console.log(years,worksYears)
  var formatCount = d3.format("4d");

  var margin = {top: 10, right: 30, bottom: 20, left: 10},
      width = 340 - margin.left - margin.right,
      height = 80 - margin.top - margin.bottom;

  var x = d3.scale.linear()
      .domain(d3.extent([1475,1978]))
      // .domain(d3.extent(years))
      .range([0, width]);
  // Generate a histogram using twenty uniformly-spaced bins.
  data = d3.layout.histogram()
      .bins(x.ticks(20))
      (years);

  dataAll = d3.layout.histogram()
      .bins(x.ticks(20))
      (worksYearsAll);

  var numbins = data.length;
  var numbinsAll = dataAll.length;
  var barWidth = width/numbins - 1;
  var barWidthAll = width/numbinsAll - 1;

  var y = d3.scale.linear()
      .domain([0, d3.max(dataAll, function(d) { return d.y; })])
      // .domain([0, d3.max(data, function(d) { return d.y; })])
      .range([height, 0]);

  var yAll = d3.scale.linear()
      .domain([0, d3.max(dataAll, function(d) { return d.y; })])
      .range([height, 0]);

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .ticks(10, "4d");

  // var svg = d3.select("#place_hist").append("svg")
  var svg = d3.select("#place_content_region").append("svg")
      .attr("id", "histYears")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var bar = svg.selectAll(".bar")
      .data(data)
    .enter().append("g")
      .attr("class", "bar")
      .attr("transform", function(d) { return "translate(" + x(d.x) + "," + y(d.y) + ")"; });

  bar.append("rect")
      .attr("x", 1)
      //.attr("width", x(data[0].dx) - 1)
      .attr("width", barWidth)
      .attr("height", function(d) { return height - y(d.y); });

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  legend = svg.append("svg:g")
  	.attr("id","hist_legend")
    // .attr("y",10).attr("x",20)
    .attr("width",150).attr("height",30)
  legend.append("text")
    .attr("class", "legend-text")
    .attr("y",20).attr("x",75)
  	.style("fill", "black")
  	.text("Place references per period")
  legend.append("rect")
  	.attr("y",5).attr("x",0)
  	.attr("width",10)
  	.attr("height",15)
    .attr("class", "legend-bar")

// overlay hollow bars for all works (dataAll, yAll)
  // TODO: get reference bars for overall placeref count in
  // var barAll = svg.selectAll(".barAll")
  //     .data(dataAll)
  //   .enter().append("g")
  //     .attr("class", "barAll")
  //     .attr("transform", function(d) { return "translate(" + x(d.x) + "," + yAll(d.y) + ")"; });
  //
  // barAll.append("rect")
  //     .attr("x", 1)
  //     //.attr("width", x(data[0].dx) - 1)
  //     .attr("width", barWidthAll)
  //     .attr("height", function(d) { return height - yAll(d.y); });

  // legend = svg.append("svg:g")
  //   .attr("id","histlegend")
  //
  // legend.append("image")
  // 	.attr("xlink:href", function(d) { return ("assets/images/hist-legend.png")})
  // 	.attr("x",1).attr("y",-5)
  // 	.attr("width",80)
  // 	.attr("height",29)
}

var packAuths = function (auths) {
  // console.log(JSON.stringify(auths))
  // TODO: variable bleed depending on # hoods?
  var bleed = 150,
      width = 340,
      height = 340;

  var pack = d3.layout.pack()
      .sort(null)
      .size([width, height])
      // .size([width, height + bleed * 2])
      .padding(2);

  // var svg = d3.select("#place_pack").append("svg")
  var svg = d3.select("#place_content_region").append("svg")
      .attr("id", "authPack")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("transform", "translate(0," + -30 + ")");
      // .attr("transform", "translate(0," + -bleed + ")");

  // d3.json(auths, function(error, json) {
    // if (error) throw error;

  var node = svg.selectAll(".node")
      .data(pack.nodes(auths)
        .filter(function(d) { return !d.children; }))
    .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")"; })
      .on("click", function(d){
        // TODO: bug, if starting in Authors, 2nd click here does not work
        AL.PlacesApp.Show.Controller.listPlacePassages(d.key)
        // console.log('vis d.key', d.key)
      });


  node.append("circle")
      .attr("r", function(d) { return d.r; })
      .attr("class", "circle-place")
      // .on("mouseover", function(d){console.log(d)})
      .append("svg:title")
        .text(function(d) { return authHash[d.key].label});;
        // .text(function(d) { return authHash[d.key]});;

  node.append("text")
      .text(function(d) { return authHash[d.key].label; })
      .style("font-size", function(d) {
        return Math.min(2 * d.r, (2 * d.r - 8) / this.getComputedTextLength() * 24) + "px";
      })
      .attr("dy", ".35em")

  // });

  d3.select(self.frameElement).style("height", height + "px");
}
