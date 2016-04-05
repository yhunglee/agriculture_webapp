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
classify_jsonobjectarray_into_different_groups_duetoattributevalue = (aryOfJSONObject) ->
  objOfGroupingJSONObject = new Object()
  for element in aryOfJSONObject
    if objOfGroupingJSONObject[element['name']]?.length
      #alert("i=#{i} at push") #debug
      objOfGroupingJSONObject[element['name']].push(element)
    else
      #alert("i=#{i} at new") #debug
      objOfGroupingJSONObject[element['name']] = [element]
    objOfDate[element.date] = 1
  objOfGroupingJSONObject 

preprocess_data_of_many_different_vegetables_for_displaying_chart = (classifiedObjectOfJSONObj,arrayOfDate,kindOfJSONObj) ->
  averagePriceOfObj = new Object()
  transactionQuantityOfObj = new Object()
  j = 0
  for element in kindOfJSONObj # split JSON format of average price and transaction quantities data of every kind into column array.
    indexOfclassifiedObjectOfJSONObj = 0
    for i in [0..arrayOfDate.length-1] by 1
      #console.log objOfDate[(classifiedObjectOfJSONObj[element][i]['date'])] #debug
      #console.log classifiedObjectOfJSONObj[element][i] #debug
      #console.log typeof classifiedObjectOfJSONObj[element][i]['date'] #debug
      #if(objOfDate["#{classifiedObjectOfJSONObj[element][i]['date']}"]?)
      if( classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]? ) # This whole if-statement block is used to align data from different kind items to same date's order.
        difference = (new Date(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['date'])).getDate() - (new Date(arrayOfDate[i])).getDate()
        if difference == 0
          #console.log "i #{i} at difference==0 push #{classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['name']} average price #{classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['total_average_price']}" #debug
          averagePriceOfObj[element] = averagePriceOfObj[element] || []
          averagePriceOfObj[element].push(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['total_average_price'])
          transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || []
          transactionQuantityOfObj[element].push(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['total_transaction_quantity'])
          indexOfclassifiedObjectOfJSONObj += 1
        else if( difference < 0)
          #console.log "i #{i} at new difference < #{difference} push #{classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['name']} average price" #debug
          averagePriceOfObj[element] = averagePriceOfObj[element] || []
          averagePriceOfObj[element].push(0)
          transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || []
          transactionQuantityOfObj[element].push(0)
          #indexOfclassifiedObjectOfJSONObj += 1
        else if ( difference > 0)
          #console.log "i #{i} at new and push, difference > #{difference} #{classifiedObjectOfJSONObj[element][i]['name']} average price" #debug
          #console.log "difference : #{difference}" #debug
          averagePriceOfObj[element] = averagePriceOfObj[element] || []
          averagePriceOfObj[element].push(0)
          transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || []
          transactionQuantityOfObj[element].push(0)          
          #averagePriceOfObj[element] = averagePriceOfObj[element] || []
          #averagePriceOfObj[element].push(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['total_average_price'])
          #transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || []
          #transactionQuantityOfObj[element].push(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['total_transaction_quantity'])

          #indexOfclassifiedObjectOfJSONObj += 1
      else
        #console.log "i #{i} at new, null of classifiedObjectOfJSONObj[element][i] "  # debug
        averagePriceOfObj[element] = averagePriceOfObj[element] || []
        averagePriceOfObj[element].push(0)
        transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || []
        transactionQuantityOfObj[element].push(0)

    #console.log(averagePriceOfObj[element]) #debug
    #console.log(transactionQuantityOfObj[element]) #debug
    #averagePriceOfObj[element].unshift("total_average_price_"+ j)
    #transactionQuantityOfObj[element].unshift("total_transaction_quantity_"+ j)
    #j += 1
    averagePriceOfObj[element].unshift(element+"平均價")
    transactionQuantityOfObj[element].unshift(element+"總交易量")
    #console.log(averagePriceOfObj[element]) #debug
    #console.log(transactionQuantityOfObj[element]) #debug

  arrayOfDate.unshift("x") # x-axis data
  console.log kindOfJSONObj # debug
  arrayOfTotalData = new Array() # store total data for chart
  arrayOfTotalData.push(arrayOfDate) # store x-axis tick data
  i = 0
  while i < kindOfJSONObj.length # push items to show multi lines in a chart
    arrayOfTotalData.push(averagePriceOfObj[kindOfJSONObj[i]])
    arrayOfTotalData.push(transactionQuantityOfObj[kindOfJSONObj[i]])
    i += 1

  arrayOfTotalData # return value
  

myJSONObj = JSON.parse(gon.myDataV_json)
objOfDate = new Object()
classifiedObjectOfJSONObj = classify_jsonobjectarray_into_different_groups_duetoattributevalue(myJSONObj)
#console.log classifiedObjectOfJSONObj #debug
#console.log Object.keys(classifiedObjectOfJSONObj) #debug
#console.log objOfDate #debug
arrayOfDate = Object.keys(objOfDate) # arayOfDate is an array of existing date in objOfDate.
kindOfJSONObj = Object.keys(classifiedObjectOfJSONObj) # return names of JSON objects. kindOfJSONObj is an array containing different name of vegetables.

if kindOfJSONObj.length <= 1
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

else

  arrayOfTotalData = preprocess_data_of_many_different_vegetables_for_displaying_chart(classifiedObjectOfJSONObj, arrayOfDate, kindOfJSONObj)
  i = 0 # for iterating index of data
  k = 0 # for iterating index of data, too
  chart = c3.generate({
    bindto: '#chart'
    data: {
      x: 'x'
      columns: arrayOfTotalData #[ 
        #arrayOfDate,
        #averagePriceOfObj[kindOfJSONObj[0]], 
        #averagePriceOfObj[kindOfJSONObj[1]],
        #transactionQuantityOfObj[kindOfJSONObj[0]],
        #transactionQuantityOfObj[kindOfJSONObj[1]]
      #]
      label: false
      axes: {
        "#{kindOfJSONObj[i]}平均價": 'y' if kindOfJSONObj[i]? #while ( kindOfJSONObj[i]?  && ((i += 1) < j))
        "#{kindOfJSONObj[k]}總交易量": 'y2' if kindOfJSONObj[k]? #while ( kindOfJSONObj[k]? && ((k += 1) < j))
        #"#{kindOfJSONObj[i]}平均價": 'y' while (i += 1) < j
        #"#{kindOfJSONObj[k]}總交易量": 'y2' while (k += 1) < j
        #total_average_price_1: 'y'
        #total_average_price_2: 'y'
        #total_transaction_quantity_1: 'y2'
        #total_transaction_quantity_2: 'y2'
        #"#{kindOfJSONObj[0]}平均價": 'y' if kindOfJSONObj[0]?
        #"#{kindOfJSONObj[1]}平均價": 'y'
        #"#{kindOfJSONObj[0]}總交易量": 'y2'
        #"#{kindOfJSONObj[1]}總交易量": 'y2'
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
          text: 'transation quantity'
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

