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

display_or_not_veggie_list = ->
  #current_value = document.getElementsByClassName('veggie-list').style.display
  #current_value = $(document).getElementsByClassName('veggie-list').style.display
  currentDisplayConfig = $('.veggie-list').css('display')
  if currentDisplayConfig == "none"
     #document.getElementsByClassName('veggie-list').style.display = "block"
     #$(document).getElementsByClassName('veggie-list').style.display = "block"
     $('.veggie-list').css('display', 'block')
     $('.btn-submit-veggie-query').css('display', 'block')
     $('.btn-veggie-list').css('left', '70%')
  else 
     #document.getElementsByClassName('veggie-list').style.display = "block"
     #$(document).getElementsByClassName('veggie-list').style.display = "block"
     $('.veggie-list').css('display', 'none')
     $('.btn-submit-veggie-query').css('display', 'none')
     $('.btn-veggie-list').css('left', '0%')

#$('.btn-veggie-list').on 'click', display_or_not_veggie_list
#$(document).on 'click','.btn-veggie-list' , display_or_not_veggie_list
$(document).off('click', '.btn-veggie-list').on 'click', '.btn-veggie-list', display_or_not_veggie_list

get_parameters_from_url = ->
  #https://stelfox.net/blog/2013/12/access-get-parameters-with-coffeescript/
  aryParams = {}
  rawVars = window.location.search.substring(1).split("&")

  queryMultipleValuePattern = /query\[\]/
  if rawVars?.length
    i = 1
    for element in rawVars
      [key, val] = element.split("=")
      if (decodeURIComponent(key)).match(queryMultipleValuePattern)
        aryParams[(decodeURIComponent(key) + "_#{i}")] = decodeURIComponent(val)
        i += 1
      else
        aryParams[decodeURIComponent(key)] = decodeURIComponent(val)
      # Fixed: have problems if there are many "query[]" item in key. 
 
  #if !(aryParams?.length) # http://stackoverflow.com/questions/8127883/easiest-way-to-check-if-string-is-null-or-empty/8127920#8127920
    #alert "response at get parameters from url function: " + JSON.stringify(aryParams,null, 4) #debug
  #else #debug
    #alert "empty"
  aryParams

append_previous_params_of_form_to_lastest_request = (previousParams) ->
  if previousParams?
    delete previousParams['query-time'] if previousParams['query-time']? # fix duplicate parameters of query-time
    delete previousParams['page'] if previousParams['page']? # fix duplicate parameters of page
    $('#filter-veggie-query input[type=hidden]').remove()

    queryMultipleValuePattern = /query\[\]_[\d]+/
    for property in Object.keys(previousParams)
      #result = property.match(queryMultipleValuePattern) #debug
      if property.match(queryMultipleValuePattern)?
      #if result? #debug
        $('#filter-veggie-query').append('<input type="hidden" name="query[]" value="' + previousParams[property] + '">')
      else
        $('#filter-veggie-query').append('<input type="hidden" name="' + property + '" value="' + previousParams[property] + '">')

submit_query_time_form_of_select_option = ->
  response = get_parameters_from_url()
  #alert "response: " + JSON.stringify(response,null,4) #debug
  #alert "response[utf8]=" + response['utf8'] + ", response[query[]]=" + response['query[]_1'] #debug
  if response?
    #alert "response at before run append_previous_params_of_form_to_lastest_request function: " + JSON.stringify(response,null,4) #debug
    append_previous_params_of_form_to_lastest_request(response)
    #alert "after run append_previous_params_of_form_to_lastest_request. " #debug
    $("#filter-veggie-query").submit() #submit the filter-veggie-query form 

$(document).off('change', '.query-time').on 'change', '.query-time', submit_query_time_form_of_select_option

