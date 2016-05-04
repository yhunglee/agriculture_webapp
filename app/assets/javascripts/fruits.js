// Generated by CoffeeScript 1.10.0
(function() {
  var append_previous_params_of_form_to_lastest_request, arrayOfDate, arrayOfTotalData, chart, classifiedObjectOfJSONObj, classify_jsonobjectarray_into_different_groups_duetoattributevalue, display_or_not_fruit_list, get_parameters_from_url, i, k, kindOfJSONObj, myJSONObj, obj, objOfDate, preprocess_data_of_many_different_fruits_for_displaying_chart, submit_query_time_form_of_select_option, switch_displayoption_using_id_for_slideshow;

  classify_jsonobjectarray_into_different_groups_duetoattributevalue = function(aryOfJSONObject) {
    var element, l, len, objOfGroupingJSONObject, ref;
    objOfGroupingJSONObject = new Object();
    for (l = 0, len = aryOfJSONObject.length; l < len; l++) {
      element = aryOfJSONObject[l];
      if ((ref = objOfGroupingJSONObject[element['code']]) != null ? ref.length : void 0) {
        objOfGroupingJSONObject[element['code']].push(element);
      } else {
        objOfGroupingJSONObject[element['code']] = [element];
      }
      objOfDate[element.date] = 1;
    }
    return objOfGroupingJSONObject;
  };

  preprocess_data_of_many_different_fruits_for_displaying_chart = function(classifiedObjectOfJSONObj, arrayOfDate, kindOfJSONObj) {
    var arrayOfTotalData, averagePriceOfObj, difference, element, i, indexOfclassifiedObjectOfJSONObj, j, l, len, m, ref, transactionQuantityOfObj;
    averagePriceOfObj = new Object();
    transactionQuantityOfObj = new Object();
    j = 0;
    for (l = 0, len = kindOfJSONObj.length; l < len; l++) {
      element = kindOfJSONObj[l];
      indexOfclassifiedObjectOfJSONObj = 0;
      for (i = m = 0, ref = arrayOfDate.length - 1; m <= ref; i = m += 1) {
        if ((classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj] != null)) {
          difference = (new Date(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['date'])).getDate() - (new Date(arrayOfDate[i])).getDate();
          if (difference === 0) {
            averagePriceOfObj[element] = averagePriceOfObj[element] || [];
            averagePriceOfObj[element].push(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['total_average_price']);
            transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || [];
            transactionQuantityOfObj[element].push(classifiedObjectOfJSONObj[element][indexOfclassifiedObjectOfJSONObj]['total_transaction_quantity']);
            indexOfclassifiedObjectOfJSONObj += 1;
          } else if (difference < 0) {
            averagePriceOfObj[element] = averagePriceOfObj[element] || [];
            averagePriceOfObj[element].push(0);
            transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || [];
            transactionQuantityOfObj[element].push(0);
          } else if (difference > 0) {
            averagePriceOfObj[element] = averagePriceOfObj[element] || [];
            averagePriceOfObj[element].push(0);
            transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || [];
            transactionQuantityOfObj[element].push(0);
          }
        } else {
          averagePriceOfObj[element] = averagePriceOfObj[element] || [];
          averagePriceOfObj[element].push(0);
          transactionQuantityOfObj[element] = transactionQuantityOfObj[element] || [];
          transactionQuantityOfObj[element].push(0);
        }
      }
      averagePriceOfObj[element].unshift(classifiedObjectOfJSONObj[element][0]['name'] + " " + classifiedObjectOfJSONObj[element][0]['kind'] + "平均價");
      transactionQuantityOfObj[element].unshift(classifiedObjectOfJSONObj[element][0]['name'] + " " + classifiedObjectOfJSONObj[element][0]['kind'] + "總交易量");
    }
    arrayOfDate.unshift("x");
    console.log(kindOfJSONObj);
    arrayOfTotalData = new Array();
    arrayOfTotalData.push(arrayOfDate);
    i = 0;
    while (i < kindOfJSONObj.length) {
      arrayOfTotalData.push(averagePriceOfObj[kindOfJSONObj[i]]);
      arrayOfTotalData.push(transactionQuantityOfObj[kindOfJSONObj[i]]);
      i += 1;
    }
    return arrayOfTotalData;
  };

  myJSONObj = JSON.parse(gon.myDataV_json);

  objOfDate = new Object();

  classifiedObjectOfJSONObj = classify_jsonobjectarray_into_different_groups_duetoattributevalue(myJSONObj);

  arrayOfDate = Object.keys(objOfDate);

  kindOfJSONObj = Object.keys(classifiedObjectOfJSONObj);

  if (kindOfJSONObj.length <= 1) {
    chart = c3.generate({
      bindto: '#fruit-chart',
      data: {
        json: myJSONObj,
        keys: {
          x: 'date',
          value: ['total_average_price', 'total_transaction_quantity']
        },
        labels: false,
        axes: {
          total_transaction_quantity: 'y2'
        }
      },
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            format: '%Y-%m-%d'
          }
        },
        y: {
          label: {
            text: 'average price',
            position: 'outer-middle'
          }
        },
        y2: {
          show: true,
          label: {
            text: 'transaction quantity',
            position: 'outer-middle'
          }
        }
      },
      zoom: {
        enabled: true
      }
    });
  } else {
    arrayOfTotalData = preprocess_data_of_many_different_fruits_for_displaying_chart(classifiedObjectOfJSONObj, arrayOfDate, kindOfJSONObj);
    i = 0;
    k = 0;
    chart = c3.generate({
      bindto: '#fruit-chart',
      data: {
        x: 'x',
        columns: arrayOfTotalData,
        label: false,
        axes: (
          obj = {},
          obj[classifiedObjectOfJSONObj[kindOfJSONObj[i]][0]['name'] + " " + classifiedObjectOfJSONObj[kindOfJSONObj[i]][0]['kind'] + "平均價"] = kindOfJSONObj[i] != null ? 'y' : void 0,
          obj[classifiedObjectOfJSONObj[kindOfJSONObj[k]][0]['name'] + " " + classifiedObjectOfJSONObj[kindOfJSONObj[k]][0]['kind'] + "總交易量"] = kindOfJSONObj[k] != null ? 'y2' : void 0,
          obj
        )
      },
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            format: '%Y-%m-%d'
          }
        },
        y: {
          label: {
            text: 'average price',
            position: 'outer-middle'
          }
        },
        y2: {
          show: true,
          label: {
            text: 'transation quantity',
            position: 'outer-middle'
          }
        }
      },
      zoom: {
        enabled: true
      }
    });
  }

  display_or_not_fruit_list = function() {
    var currentDisplayConfig;
    currentDisplayConfig = $('.fruit-list').css('display');
    if (currentDisplayConfig === "none") {
      $('.fruit-list').css('display', 'block');
      $('.btn-submit-fruit-query').css('display', 'block');
      return $('.btn-fruit-list').css('left', '70%');
    } else {
      $('.fruit-list').css('display', 'none');
      $('.btn-submit-fruit-query').css('display', 'none');
      return $('.btn-fruit-list').css('left', '0%');
    }
  };

  $(document).off('click', '.btn-fruit-list').on('click', '.btn-fruit-list', display_or_not_fruit_list);

  get_parameters_from_url = function() {
    var aryParams, element, key, l, len, queryMultipleValuePattern, rawVars, ref, val;
    aryParams = {};
    rawVars = window.location.search.substring(1).split("&");
    queryMultipleValuePattern = /query\[\]/;
    if (rawVars != null ? rawVars.length : void 0) {
      i = 1;
      for (l = 0, len = rawVars.length; l < len; l++) {
        element = rawVars[l];
        ref = element.split("="), key = ref[0], val = ref[1];
        if ((decodeURIComponent(key)).match(queryMultipleValuePattern)) {
          aryParams[decodeURIComponent(key) + ("_" + i)] = decodeURIComponent(val);
          i += 1;
        } else {
          aryParams[decodeURIComponent(key)] = decodeURIComponent(val);
        }
      }
    }
    return aryParams;
  };

  append_previous_params_of_form_to_lastest_request = function(previousParams) {
    var l, len, property, queryMultipleValuePattern, ref, results;
    if (previousParams != null) {
      if (previousParams['query-time'] != null) {
        delete previousParams['query-time'];
      }
      if (previousParams['page'] != null) {
        delete previousParams['page'];
      }
      $('#filter-fruit-query input[type=hidden]').remove();
      queryMultipleValuePattern = /query\[\]_[\d]+/;
      ref = Object.keys(previousParams);
      results = [];
      for (l = 0, len = ref.length; l < len; l++) {
        property = ref[l];
        if (property.match(queryMultipleValuePattern) != null) {
          results.push($('#filter-fruit-query').append('<input type="hidden" name="query[]" value="' + previousParams[property] + '">'));
        } else {
          results.push($('#filter-fruit-query').append('<input type="hidden" name="' + property + '" value="' + decodeURIComponent(previousParams[property].replace(/\+/g, " ")) + '">'));
        }
      }
      return results;
    }
  };

  submit_query_time_form_of_select_option = function() {
    var response;
    response = get_parameters_from_url();
    if (response != null) {
      append_previous_params_of_form_to_lastest_request(response);
      return $("#filter-fruit-query").submit();
    }
  };

  $(document).off('change', '.fruit-query-time').on('change', '.fruit-query-time', submit_query_time_form_of_select_option);

  $('.slideshow').slick({
    slidesToShow: 9,
    slidesToScroll: 9,
    variableWidth: true,
    rows: 4,
    autoplay: true,
    autoplaySpeed: 7000,
    responsive: [
      {
        breakpoint: 400,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
          rows: 2,
          autoplay: true,
          autoplaySpeed: 2000
        }
      }, {
        breakpoint: 768,
        settings: {
          slidesToShow: 5,
          slidesToScroll: 5,
          rows: 2,
          autoplay: true,
          autoplaySpeed: 5000
        }
      }
    ]
  });

  switch_displayoption_using_id_for_slideshow = function(idName) {
    var display_value;
    display_value = $('.showdata .slideshow [class^=item-] ' + idName).css('display');
    if (!(display_value != null)) {

    } else if (display_value !== 'none') {
      return $('.showdata .slideshow [class^=item-] ' + idName).css('display', 'none');
    } else {
      return $('.showdata .slideshow [class^=item-] ' + idName).css('display', 'block');
    }
  };

  $('.display-option .location').click(function() {
    return switch_displayoption_using_id_for_slideshow('#location');
  });

  $('.display-option .middleprice').click(function() {
    return switch_displayoption_using_id_for_slideshow('#middleprice');
  });

  $('.display-option .upperprice').click(function() {
    return switch_displayoption_using_id_for_slideshow('#upperprice');
  });

  $('.display-option .lowerprice').click(function() {
    return switch_displayoption_using_id_for_slideshow('#lowerprice');
  });

  $('.display-option .averageprice').click(function() {
    return switch_displayoption_using_id_for_slideshow('#averageprice');
  });

  $('.display-option .quantity').click(function() {
    return switch_displayoption_using_id_for_slideshow('#quantity');
  });

  $('.display-option .kind').click(function() {
    return switch_displayoption_using_id_for_slideshow('#kind');
  });

  $('.display-option .processtype').click(function() {
    return switch_displayoption_using_id_for_slideshow('#processtype');
  });

  $('.display-option .date').click(function() {
    return switch_displayoption_using_id_for_slideshow('#date');
  });

}).call(this);
