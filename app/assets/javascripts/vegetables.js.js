// Generated by CoffeeScript 1.10.0
(function() {
  var append_previous_params_of_form_to_lastest_request, chart, display_or_not_veggie_list, get_parameters_from_url, myJSONObj, submit_query_time_form_of_select_option;

  myJSONObj = JSON.parse(gon.myDataV_json);

  chart = c3.generate({
    bindto: '#chart',
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
    }
  });

  display_or_not_veggie_list = function() {
    var currentDisplayConfig;
    currentDisplayConfig = $('.veggie-list').css('display');
    if (currentDisplayConfig === "none") {
      $('.veggie-list').css('display', 'block');
      $('.btn-submit-veggie-query').css('display', 'block');
      return $('.btn-veggie-list').css('left', '70%');
    } else {
      $('.veggie-list').css('display', 'none');
      $('.btn-submit-veggie-query').css('display', 'none');
      return $('.btn-veggie-list').css('left', '0%');
    }
  };

  $(document).off('click', '.btn-veggie-list').on('click', '.btn-veggie-list', display_or_not_veggie_list);

  get_parameters_from_url = function() {
    var aryParams, element, i, j, key, len, queryMultipleValuePattern, rawVars, ref, val;
    aryParams = {};
    rawVars = window.location.search.substring(1).split("&");
    queryMultipleValuePattern = /query\[\]/;
    if (rawVars != null ? rawVars.length : void 0) {
      i = 1;
      for (j = 0, len = rawVars.length; j < len; j++) {
        element = rawVars[j];
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
    var j, len, property, queryMultipleValuePattern, ref, results;
    if (previousParams != null) {
      if (previousParams['query-time'] != null) {
        delete previousParams['query-time'];
      }
      if (previousParams['page'] != null) {
        delete previousParams['page'];
      }
      $('#filter-veggie-query input[type=hidden]').remove();
      queryMultipleValuePattern = /query\[\]_[\d]+/;
      ref = Object.keys(previousParams);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        property = ref[j];
        if (property.match(queryMultipleValuePattern) != null) {
          results.push($('#filter-veggie-query').append('<input type="hidden" name="query[]" value="' + previousParams[property] + '">'));
        } else {
          results.push($('#filter-veggie-query').append('<input type="hidden" name="' + property + '" value="' + previousParams[property] + '">'));
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
      return $("#filter-veggie-query").submit();
    }
  };

  $(document).off('change', '.query-time').on('change', '.query-time', submit_query_time_form_of_select_option);

}).call(this);
