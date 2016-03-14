# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#  svg_width = 1500
#  svg_height = 500
#  bar_padding = 5
#  myJSONObj = JSON.parse(gon.myDataV_json)
#  svg = d3.select("body").append("svg").attr("width", svg_width).attr("height", svg_height)
#  svg.selectAll("rect").data(myJSONObj).enter().append("rect").attr("x", (d, i) ->
#    i * svg_width / myJSONObj.length
#  ).attr("y", (d) ->
#    svg_height - (d.total_average_price * 20)
#  ).attr("width", svg_width / myJSONObj.length - bar_padding).attr("height", (d) ->
#    d.total_average_price * 20
#  ).attr "fill", (d) ->
#    "rgb(" + d.total_average_price * 25 + ",30,0)"

#  svg.selectAll("text").data(myJSONObj).enter().append("text").text((d) ->
#    d.total_average_price
#  ).attr("text-anchor", "middle").attr("x", (d, i) ->
#    i * (svg_width / myJSONObj.length) + (svg_width / myJSONObj.length - bar_padding) / 2
#  ).attr("y", (d) ->
#    svg_height - (d.total_average_price * 20) + 20
#  ).attr("font-family", "sans-serif").attr("font-size", "20px").attr "fill", "white"
#
myJSONObj = JSON.parse(gon.myDataV_json)
chart = c3.generate({
  bindto: '#chart'
  data: {
    json: myJSONObj
    keys: {
      x: 'date'
      value: ['total_average_price','total_transaction_quantity']
    }
    labels: false
    axes: {
      total_transaction_quantity: 'y2'
    }
  },
  axis: {
    x: {
      type: 'timeseries'
      tick: {
        format: '%Y-%m-%d'
      }
    },
    y: {
      label: {
        text: 'average price'
        position: 'outer-middle'
      }
    },
    y2: {
      show: true
      label: {
        text: 'transaction quantity'
        position: 'outer-middle'
      }
    }
  }
})

