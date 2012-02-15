jQuery(document).ready ->
  $.datepicker.setDefaults $.datepicker.regional["ru"]

  $('.add').click ->
    $.ajax
      url: '/people/new'
      complete: (resp) ->
        $('.people').append resp.responseText
        $('#person_phones').mask("+7 999 999 9999");
        $('.new_person').find('input, select').keyup (e) ->
          if e.keyCode is 13
            data = $('.new_person').find('*').serialize()
            $.ajax
              url: '/people'
              type: "post"
              data: data
              complete: (new_person) ->
                $(".new_person").replaceWith new_person.responseText



  $('.person').click ->
    id = @id
    element = $(this)
    $('*').removeClass('selected')
    element.addClass('selected')
    $.ajax
      url: 'communications/' + this.id
      complete: (resp) ->
        $('.communications').html resp.responseText
        $('.controls').empty()
        $('.controls').append ('<a href=\'#\' class=\"button call\" id=\"' + id + '\">звонок</a>')
        $('.controls').append ('<a href=\'#\' class=\"button meet\" id=\"' + id + '\">встреча</a>')

  $('.button.meet').live 'click', ->
    $.ajax
      url: '/people/' + $('.selected')[0].id + '/communications/new'
      complete: (resp) ->
        $('.communications.table').append resp.responseText
        $("option[value='meet']").attr('selected', 'selected')

        $('#communication_action_date').datepicker
          numberOfMonths: 3
          showButtonPanel: true
          locale: 'ru'
        $('#communication_next_action_date').datepicker
          numberOfMonths: 3
          showButtonPanel: true
          locale: 'ru'

        $(".new_communication").find('input,select').keyup (e) ->
          if e.keyCode is 13
            data = $('.new_communication').find('*').serialize()
            $.ajax
              url: '/people/' + $('.new_communication')[0].id + '/communications'
              type: "post"
              data: data
              complete: (new_car) ->
                $(".new_communication").replaceWith new_car.responseText
            false

  $('.button.call').live 'click', ->
    $.ajax
      url: '/people/' + $('.selected')[0].id + '/communications/new'
      complete: (resp) ->
        $('.communications.table').append resp.responseText
        $("option[value='call']").attr('selected', 'selected')

        $('#communication_action_date').datepicker
          numberOfMonths: 3
          showButtonPanel: true
          locale: 'ru'
        $('#communication_next_action_date').datepicker
          numberOfMonths: 3
          showButtonPanel: true
          locale: 'ru'

        $(".new_communication").find('input,select').keyup (e) ->
          if e.keyCode is 13
            data = $('.new_communication').find('*').serialize()
            $.ajax
              url: '/people/' + $('.new_communication')[0].id + '/communications'
              type: "post"
              data: data
              complete: (new_car) ->
                $(".new_communication").replaceWith new_car.responseText
            false
#          if e.keyCode is 27


