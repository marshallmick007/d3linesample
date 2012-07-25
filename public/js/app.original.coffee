#require "./d3shim.js"
#https://github.com/vlandham/vlandham.github.com/blob/master/vis/coffee/nationality_by_city.coffee
#
$ ->
  data = [
    {date: new Date(2012,0,1, 8, 0, 0), measure: 3.2},
    {date: new Date(2012,0,1, 8, 0, 15), measure: 3.9},
    {date: new Date(2012,0,1, 8, 0, 30), measure: 6.2},
    {date: new Date(2012,0,1, 8, 0, 45), measure: 15.2},
    {date: new Date(2012,0,1, 8, 1, 0), measure: 30},
    {date: new Date(2012,0,1, 8, 1, 15), measure: 37.9},
    {date: new Date(2012,0,1, 8, 1, 30), measure: 49},
    {date: new Date(2012,0,1, 8, 1, 45), measure: 59},
    {date: new Date(2012,0,1, 8, 2, 0), measure: 112.0},
    {date: new Date(2012,0,1, 8, 2, 15), measure: 53.2},
    {date: new Date(2012,0,1, 8, 2, 30), measure: 23.7},
    {date: new Date(2012,0,1, 8, 2, 45), measure: 3.9},
    {date: new Date(2012,0,1, 8, 3, 0), measure: 3.1},
    {date: new Date(2012,0,1, 8, 3, 15), measure: 5.2},
    {date: new Date(2012,0,1, 8, 3, 30), measure: 5.2},
    {date: new Date(2012,0,1, 8, 3, 45), measure: 8.2}
  ]

  computeY = (d) ->
    if d.measure > 60
      new Date(2012,0,1,0,0, 120 -d.measure)
    else
      new Date(2012,0,1,0,1, 60 - d.measure)

  width = 400
  height = 200
  margin = 30
  yAxisScale = 15
  yIntervals = 4
  xIntervals = 5
  totalMeasures = 96  # 24 hrs * 4 15 minute increments
  totalSeconds = 120  # 2 minute IIS timeout
  x = d3.time.scale()
    .domain([data[0].date, data[data.length-1].date])
    .range([0, width])
  y = d3.time.scale()
    .domain([new Date(2012,0,1,0,0,0), new Date(2012,0,1,0,2,0)])
    .range([0, height])

  # for now, just returning the value
  yAxisLabel = (d) ->
    d

  # Add our SVG to the DOM

  vis = d3.select("#graph")
          .append("svg:svg")
          .attr("width", width + margin * 2)
          .attr("height", height + margin * 2)

  #create a group to hold the axis-related elements
  axg = vis.append("svg:g")
        .attr("transform", "translate("+ margin + ", " + margin + ")")

  # TODO: as new elements come in, adjust the range to be the highest value
  #       seen + a little margin at the top of the graph
  axg.selectAll(".yTicks")
    .data(d3.range(0,totalSeconds/yAxisScale))
    .enter().append("svg:line")
    .attr("x1", -5)
    .attr("y1", (d) -> d3.round( y( new Date(2012,0,1,0,0,d*yAxisScale) ) + 0.5 ) )
    .attr("x2", width + 5)
    .attr("y2", (d) -> d3.round( y( new Date(2012,0,1,0,0,d*yAxisScale) ) + 0.5 ) )
    .attr("stroke", "lightgray")
    .attr("class", "yTicks")

  axg.selectAll(".xTicks")
    .data(d3.range(0, data.length).map( (i) -> data[i].date ) )
    .enter().append("svg:line")
    .attr("x1", x)
    .attr("y1", -5)
    .attr("x2", x)
    .attr("y2", height + 5)
    .attr("stroke", "lightgray")
    .attr("class", "xTicks")

  axg.selectAll(".xLabel")
    .data(d3.range(0, data.length).map( (i) -> data[i].date ) )
    .enter()
    .append("svg:text")
    .text((d,i) -> data[i].date.getMinutes() )
    .attr("x", x)
    .attr("y", height+15)
    .attr("text-anchor", "middle")
    .attr("class", "xAxisBottom")
  
  axg.selectAll(".yLabel")
    .data(d3.range(0,totalSeconds/yAxisScale) )
    .enter()
    .append("svg:text")
    .text((d,i) -> totalSeconds - (i * yAxisScale) )
    .attr("x", -30)
    .attr("y",  (d) -> d3.round( y( new Date(2012,0,1,0,0,d*yAxisScale) ) + 0.5 ) )
    .attr("dy", "3")
    .attr("text-anchor", "start")
    .attr("class", "yAxisLeft")

  axg.append("svg:rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("height", height)
    .attr("width", width)
    .attr("fill", "lightyellow")

  lineGroup = vis.append("svg:g")
              .attr("transform", "translate("+ margin + ", " + margin + ")")

  # define the line. TODO: the .y function needs to be aware of 60+ seconds
  line = d3.svg.line()
               .x( (d) -> x( d.date ) )
               .y( (d) -> y( computeY( d ) ) )

  # add the line to the path
  lineGroup.append("svg:path").attr("d", line(data))

  update = () -> d3.json('/api/1/random', (d) ->
    if lineGroup
      lineGroup.remove()

    lineGroup = vis.append("svg:g")
              .attr("transform", "translate("+ margin + ", " + margin + ")")

    # define the line. TODO: the .y function needs to be aware of 60+ seconds
    line = d3.svg.line()
               .x( (d) -> x( new Date().setTime(Date.parse(d.date))) )
               .y( (d) -> y( computeY( d ) ) )

    # add the line to the path
    lineGroup.append("svg:path").attr("d", line(d))
  )

  callback = @update.bind @
  setInterval callback, 5000

