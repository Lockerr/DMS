jQuery(document).ready ->
  $.datepicker.setDefaults $.datepicker.regional["ru"]

  $('.print_contract').live 'click', ->
    id = @id
    $.ajax
      url: 'contracts/' + id
      type: 'PUT'
      data: $('.contract_form').find('*').serialize()
      complete: ->
        window.open ("http://0.0.0.0:3000/contracts/" + id + '.pdf')

  $('#calendar').click ->
    $.ajax
      url: '/calendar'
      complete: (resp) ->
        $('.mid-box').html resp.responseText

        $('.day').click ->
          $.ajax
            url: '/calendar/' + $(this).attr('day') + '/day'
            complete: (resp) ->
              $('.top-box').html resp.responseText

              $('.communication').click ->
                $.ajax
                  url: 'communications/' + @id + '/short/'
                  complete: (resp) ->
                    $('.top-right').html resp.responseText

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
        $('.controls').append ('<a href=\'#\' class=\"button contract\" id=\"' + id + '\">контракт</a>')

        $(".button.contract").click ->
          id = @id
          $.ajax
            url: 'contracts/new?person=' + id
            complete: (html) ->
              $('.contract_form').html html.responseText
              $('#contract_car_id').combobox()

              $(".new_contract").dialog
                autoOpen: false
                hide: "explode"
                modal: true
                width: 700
                close: ->
                  $(".new_contract").dialog( "destroy" )
                  $(".new_contract").remove()

              $(".new_contract").dialog "open"

              $('#person_birthday').datepicker
			          changeYear: true
                changeMonth: true
                yearRange: "-20:-10"


			        $('#contract_date').datepicker
                changeMonth: true
                yearRange: "-20:-10"
			          changeYear: true



  $('.button.meet').live 'click', ->
    $.ajax
      url: '/people/' + $('.selected')[0].id + '/communications/new'
      complete: (resp) ->
        $('.communications.table').append resp.responseText
        $("option[value='встреча']").attr('selected', 'selected')

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
        $("option[value='звонок']").attr('selected', 'selected')

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

