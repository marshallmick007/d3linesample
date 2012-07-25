#require "./d3shim.js"
#https://github.com/vlandham/vlandham.github.com/blob/master/vis/coffee/nationality_by_city.coffee
#
$ ->
  data = [3, 6, 2, 7, 5, 2, 1, 3, 8, 9, 2, 5, 7]
  chartWidth = 400
  chartHeight = 200
  chartMargin = 20
  yIntervals = 4
  xIntervals = 5
  x = d3.scale.linear()
    .domain([0, data.length])
    .range([0 + chartMargin, chartWidth - chartMargin])
  y = d3.scale.linear()
    .domain([0, d3.max(data)])
    .range([0 + chartMargin, chartHeight - chartMargin])

  # Add our SVG to the DOM

  vis = d3.select("#graph")
          .append("svg:svg")
          .attr("width", chartWidth)
          .attr("height", chartHeight)

  #move the group down 200 pixels
  g = vis.append("svg:g")
         .attr("transform", "translate(0,200)")

  # define the line
  line = d3.svg.line()
               .x( (d,i) -> x(i) )
               .y( (d) -> -1 * y(d) )

  # add the line to the path
  g.append("svg:path").attr("d", line(data))

  #Create axises

  g.append("svg:line")
    .attr("x1", x(0))
    .attr("y1", -1 * y(0))
    .attr("x2", x(chartWidth))
    .attr("y2", -1 * y(0))

  g.append("svg:line")
    .attr("x1", x(0))
    .attr("y1", -1 * y(0))
    .attr("x2", x(0))
    .attr("y2", -1 * y(d3.max(data)))

  g.selectAll(".xLabel")
    .data(x.ticks(xIntervals))
    .enter().append("svg:text")
    .attr("class", "xLabel")
    .text(String)
    .attr("x", (d) ->  x(d))
    .attr("y", -2)
    .attr("text-anchor", "middle")

  g.selectAll(".yLabel")
    .data(y.ticks(yIntervals))
    .enter().append("svg:text")
    .attr("class", "yLabel")
    .text(String)
    .attr("x", 2)
    .attr("y", (d) ->  -1 * y(d) )
    .attr("text-anchor", "right")
    .attr("dy", 4)


