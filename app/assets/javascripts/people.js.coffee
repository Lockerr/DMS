show_respond = (html) ->
  $('.respond').html html.responseText

  $(".respond").dialog
    autoOpen: false
    hide: "explode"
    modal: true
    width: 700
    close: ->
     $(".respond").dialog( "destroy" )

  $(".respond").dialog 'open'

prepare_respond = (html) ->
  $('.respond').html html.responseText

open_respond = ->
  $(".respond").dialog
    autoOpen: false
    hide: "explode"
    modal: true
    width: 700
    close: ->
      $(".respond").dialog( "destroy" )

  $(".respond").dialog 'open'



#TODO Отсортировать
jQuery(document).ready ->
  $.datepicker.setDefaults $.datepicker.regional["ru"]

  $('.filters.header input.filter').typeWatch
    callback: ->
      $.ajax
        url: "people.js"
        data: $('.filters').find('*').serialize()
        complete: (html) ->
          $(".people").html html.responseText
    wait: 500
    highlight: false
    captureLength: 0


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


  $("#filters_clear").live 'click', ->
      $(".filters input").each ->
        @value = ""
      $.ajax
        url: "people.js"
        complete: (html) ->
          $(".people").html html.responseText

  $('.person').live 'dblclick', ->
    id = @id
    $.ajax
      url: 'people/' + id+ '/edit'
      complete: (html) ->
        prepare_respond(html)

        $('input#person_phone').mask("+7 999 999 99 99")
        phone_input = "<div class=\"phone\"><div class=\"label\">Телефон</div><input id=\"person_phone\" name=\"person[phones][2]\" size=\"30\" type=\"text\"></div>"
        $('.add_phone').click ->
          if ($('input#person_phone').size() > 1)
            id = ($('input#person_phone').size() + 1)
            phone_input = "<div class=\"phone\"><div class=\"label\">Телефон</div><input id=\"person_phone\" name=\"person[phones][" + id+"]\" size=\"30\" type=\"text\"></div>"
            $('input#person_phone').last().after phone_input
          else
            $('.add_phone').after phone_input
          $('input#person_phone').last().mask("+7 999 999 99 99")
          $('input#person_phone').last().focus()

        $('.update_person').click ->
          request = $.ajax
            url: 'people/' + id
            type: 'PUT'
            data: $('.person_form').find('*').serialize()
            success: ->
              $('.respond').dialog('destroy')
              $.ajax
                url: "people.js"
                complete: (html) ->
                  $(".people").html html.responseText

          request.fail (xhr,satus,error) ->
            $('#error_explanation').remove()
            $('.person_form').prepend(xhr.responseText)

          $('.respond').dialog 'destroy'

        $('#person_model_id').combobox()
        $('#person_model_id')

        open_respond()

        $('.cancel').click ->
          $('.respond').dialog 'destroy'

  $('#contact_add').click ->
    $.ajax
      url: 'people/new'
      complete: (html) ->

        prepare_respond(html)

        $('input#person_phone').mask("+7 999 999 99 99")
        phone_input = "<div class=\"phone\"><div class=\"label\">Телефон</div><input id=\"person_phone\" name=\"person[phones][2]\" size=\"30\" type=\"text\"></div>"
        $('.add_phone').click ->
          if ($('input#person_phone').size() > 1)
            id = ($('input#person_phone').size() + 1)
            phone_input = "<div class=\"phone\"><div class=\"label\">Телефон</div><input id=\"person_phone\" name=\"person[phones][" + id+"]\" size=\"30\" type=\"text\"></div>"
            $('input#person_phone').last().after phone_input
          else
            $('.add_phone').after phone_input
          $('input#person_phone').last().mask("+7 999 999 99 99")
          $('input#person_phone').last().focus()
        $('.person_create').click ->
          request = $.ajax
            url: 'people'
            type: 'POST'
            data: $('.new_person').find('*').serialize()
            success: (html) ->
              show_respond html
              $('.respond').dialog('destroy')
          request.fail (xhr,satus,error) ->
            $('#error_explanation').remove()
            $('.new_person').prepend(xhr.responseText)
        $('#person_model_id').combobox()
        $('#person_model_id')

        open_respond()



  $('.person').live 'click', ->
    id = @id
    element = $(this)
    $('*').removeClass('selected')
    element.addClass('selected')
    $.ajax
      url: 'communications/' + this.id
      complete: (resp) ->
        $('.communications').html resp.responseText
        $('.button.call').remove()
        $('.button.meet').remove()
        $('.button.contract').remove()

        $('.controls').append ('<a href=\'#\' class=\"button call\" id=\"' + id + '\">звонок</a>')
        $('.controls').append ('<a href=\'#\' class=\"button meet\" id=\"' + id + '\">встреча</a>')
#        $('.controls').append ('<a href=\'#\' class=\"button contract\" id=\"' + id + '\">контракт</a>')

#        $(".button.contract").click ->
#          id = @id
#          $.ajax
#            url: 'contracts/new?person=' + id
#            complete: (html) ->
#              $('.contract_form').html html.responseText
#              $('#contract_car_id').combobox()
#
#              $(".new_contract").dialog
#                autoOpen: false
#                hide: "explode"
#                modal: true
#                width: 700
#                close: ->
#                  $(".new_contract").dialog( "destroy" )
#                  $(".new_contract").remove()
#
#              $(".new_contract").dialog("open")
#
#              $('#person_birthday').datepicker
#                changeYear: 'true'
#                changeMonth: 'true'
#                yearRange: '-100:-16'
#
#              $('#contract_date').datepicker
#                changeMonth: true
#                changeYear: true

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


