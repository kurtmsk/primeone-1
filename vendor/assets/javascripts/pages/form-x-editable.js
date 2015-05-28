$(function(){
  /*
  //ajax mocks
  $.mockjaxSettings.responseTime = 500;

  $.mockjax({
    url: '/post',
    response: function(settings) {
      log(settings, this);
    }
  });

  $.mockjax({
    url: '/error',
    status: 400,
    statusText: 'Bad Request',
    response: function(settings) {
      this.responseText = 'Please input correct value';
      log(settings, this);
    }
  });

  $.mockjax({
    url: '/status',
    status: 500,
    response: function(settings) {
      this.responseText = 'Internal Server Error';
      log(settings, this);
    }
  });

  $.mockjax({
    url: '/groups',
    response: function(settings) {
      this.responseText = [
        {value: 0, text: 'Guest'},
        {value: 1, text: 'Service'},
        {value: 2, text: 'Customer'},
        {value: 3, text: 'Operator'},
        {value: 4, text: 'Support'},
        {value: 5, text: 'Admin'}
      ];
      log(settings, this);
    }
  });

  function log(settings, response) {
    var s = [], str;
    s.push(settings.type.toUpperCase() + ' url = "' + settings.url + '"');
    for(var a in settings.data) {
      if(settings.data[a] && typeof settings.data[a] === 'object') {
        str = [];
        for(var j in settings.data[a]) {str.push(j+': "'+settings.data[a][j]+'"');}
        str = '{ '+str.join(', ')+' }';
      } else {
        str = '"'+settings.data[a]+'"';
      }
      s.push(a + ' = ' + str);
    }
    s.push('RESPONSE: status = ' + response.status);

    if(response.responseText) {
      if($.isArray(response.responseText)) {
        s.push('[');
        $.each(response.responseText, function(i, v){
          s.push('{value: ' + v.value+', text: "'+v.text+'"}');
        });
        s.push(']');
      } else {
        s.push($.trim(response.responseText));
      }
    }
    s.push('--------------------------------------\n');
    $('#console').val(s.join('\n') + $('#console').val());
  }

  */
  /*
  $('#firstname').editable({
    validate: function(value) {
      if($.trim(value) == '') return 'This field is required';
    }
  });
  */


  //defaults
  $.fn.editable.defaults.url = '/policy';
  $.fn.editable.defaults.mode = 'inline';
  $.fn.editable.defaults.ajaxOptions = {type: "PATCH"};

  //editables

  $('#policy_number').editable({
    params: function(params) {
      var data = {};
      data['policy'] = {};
      data['policy'][params.name] = params.value
      data['id'] = params.pk;
      data[params.name] = params.value

      return data;
    },

    success: function(response, newValue) {
      $('.policy_number_display').text(newValue);
    }
  });

  $('#client_code').editable({
    params: function(params) {
      var data = {};
      data['policy'] = {};
      data['policy'][params.name] = params.value
      data['id'] = params.pk;
      data[params.name] = params.value

      return data;
    },

    success: function(response, newValue) {
      $('.client_code_display').text(newValue);
    }
  });

$('#status').editable({
  params: function(params) {
    var data = {};
    data['policy'] = {};
    data['policy'][params.name] = params.value
    data['id'] = params.pk;
    data[params.name] = params.value

    return data;
  },

  source: [
    {value: 'Upcoming', text: 'Upcoming'},
    {value: 'Generated', text: 'Generated'},
    {value: 'Reviewed', text: 'Reviewed'},
    {value: 'Issued', text: 'Issued'}
  ],
});

$('#expiration_date').editable({
  params: function(params) {
    var data = {};
    data['policy'] = {};
    data['policy'][params.name] = params.value
    data['id'] = params.pk;
    data[params.name] = params.value

    return data;
  },

  viewformat: 'MM/DD/YYYY',
  template: 'D / MMMM / YYYY',
  combodate: {
    minYear: 1950,
    maxYear: 2050,
    minuteStep: 1
  }
});

$('#effective_date').editable({
  params: function(params) {
    var data = {};
    data['policy'] = {};
    data['policy'][params.name] = params.value
    data['id'] = params.pk;
    data[params.name] = params.value

    return data;
  },

  viewformat: 'MM/DD/YYYY',
  template: 'MMM / D / YYYY',
  combodate: {
    minYear: 1950,
    maxYear: 2050,
    minuteStep: 1
  }
});

$('#address').editable({
  params: function(params) {
    var data = {};
    data['policy'] = {};
    data['policy']['street'] = params.value.street;
    data['policy']['city'] = params.value.city;
    data['policy']['state'] = params.value.state;
    data['policy']['zip'] = params.value.zip;
    data['id'] = params.pk;

    return data;
  },

  validate: function(value) {
    if(value.city == '') return 'City is required!';
    if(value.state == '') return 'State is required!';
    if(value.zip == '') return 'Zip Code is required!';
    if(value.street == '') return 'Street is required!';
  }
});

var countries = [];
$.each({1: "Broker 1", 2: "Broker 2", 3: "Broker 3", 4: "Broker 4"}, function(k, v) {
  countries.push({id: k, text: v});
});

$('#broker_id').editable({

  params: function(params) {
    var data = {};
    data['policy'] = {};
    data['policy']['broker_id'] = params.value
    data['id'] = params.pk;

    return data;
  },

  source: countries,
  select2: {
    width: 300,
    placeholder: 'Select Broker',
    allowClear: true
  }
});

$('.editable').editable({
  params: function(params) {
    var data = {};
    data['policy'] = {};
    data['policy'][params.name] = params.value
    data['id'] = params.pk;
    data[params.name] = params.value

    return data;
  }
});



$('#event').editable({
  placement: 'right',
  combodate: {
    firstItem: 'name'
  }
});

$('#meeting_start').editable({
  format: 'yyyy-mm-dd hh:ii',
  viewformat: 'dd/mm/yyyy hh:ii',
  validate: function(v) {
    if(v && v.getDate() == 10) return 'Day cant be 10!';
  },
  datetimepicker: {
    todayBtn: 'linked',
    weekStart: 1
  }
});

$('#comments').editable({
  showbuttons: 'bottom'
});

$('#note').editable();
$('#pencil').click(function(e) {
  e.stopPropagation();
  e.preventDefault();
  $('#note').editable('toggle');
});

$('#state').editable({
  source: ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Dakota","North Carolina","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
});

$('#state2').editable({
  value: 'California',
  typeahead: {
    name: 'state',
    local: ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Dakota","North Carolina","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
  }
});

$('#fruits').editable({
  pk: 1,
  limit: 3,
  source: [
    {value: 1, text: 'banana'},
    {value: 2, text: 'peach'},
    {value: 3, text: 'apple'},
    {value: 4, text: 'watermelon'},
    {value: 5, text: 'orange'}
  ]
});

$('#tags').editable({
  inputclass: 'input-large',
  select2: {
    tags: ['html', 'javascript', 'css', 'ajax'],
    tokenSeparators: [",", " "]
  }
});




$('#policy .editable').on('hidden', function(e, reason){
  if(reason === 'save' || reason === 'nochange') {
    var $next = $(this).closest('tr').next().find('.editable');
    if($('#autoopen').is(':checked')) {
      setTimeout(function() {
        $next.editable('show');
      }, 300);
    } else {
      $next.focus();
    }
  }
});
});
