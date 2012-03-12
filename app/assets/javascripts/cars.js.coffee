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



revert_date = (date) ->
  splitted = date.split('-')
  return splitted[2] + '.' + splitted[1] + '.' + splitted[0]


jQuery(document).ready ->

  $("input.filter").typeWatch
    callback: ->
      $.ajax
        url: "cars.js"
        data: $('.filters').find('*').serialize()
        complete: (html) ->
          $(".cars").html html.responseText
    wait: 500
    highlight: false
    captureLength: 0

  $('input#search_arrival_from').datepicker
    changeYear: 'true'
    changeMonth: 'true'

  $('input#search_arrival_to').datepicker
    changeYear: 'true'
    changeMonth: 'true'

  $('input#search_prod_date_from').datepicker
    changeYear: 'true'
    changeMonth: 'true'

  $('input#search_prod_date_to').datepicker
    changeYear: 'true'
    changeMonth: 'true'

  $(".new_car").dialog
    autoOpen: false
    hide: "explode"
    modal: true
    width: 700

  $('.clear_search').live 'click', ->
    $(".filters").find("input#search_" + this.id)[0].value = ''

  $(".button.contract").live 'click', ->
    id = @id
    $.ajax
      url: 'contracts/new?car=' + id
      complete: (html) ->
        $('.contract_form').html html.responseText
        $('#contract_person_id').combobox()



        $(".new_contract").dialog
          autoOpen: false
          hide: "explode"
          modal: true
          width: 700
          close: ->
            $(".new_contract").dialog( "destroy" )
            $(".new_contract").remove()

        $(".new_contract").dialog "open"
        $('#contract_date').datepicker()

        $('#person_birthday').datepicker
          changeYear: 'true'
          changeMonth: 'true'
          yearRange: '-100:-16'


        $('input#person_phones').mask("+7 *** *** ** **")
        $('input#person_id_series').mask("****")
        $('input#person_id_number').mask("******")
        $('input#contract_price').mask("9?9999999")
        $('input#contract_prepay').mask("9?9999999")

        $('select#contract_person_id').change ->
          id = $('.contract_form').find('select').find('option:selected')[0].value
          $.ajax
            url: 'people/' + id + '.json'
            complete: (json) ->
              person = $.parseJSON json.responseText
              $('input#person_id_series').val(person.id_series)
              $('input#person_id_number').val(person.id_number)
              $('input#person_id_dep').val(person.id_dep)
              $('input#person_phones').val(person.phones)
              $('input#person_address').val(person.address)
              $('input#person_birthday').val(revert_date(person.birthday))
              $('input#person_name').val(person.name)
              $('#person_birthday').datepicker()
                changeYear: 'true'
                changeMonth: 'true'
                yearRange: '-100:-16'
              $('input#person_phones').mask("+7 *** *** ** **")
              $('input#person_id_series').mask("****")
              $('input#person_id_number').mask("******")
              $('input#contract_price').mask("9?9999999")
              $('input#contract_prepay').mask("9?9999999")
        $('.contract_cancel').click ->
          $('.new_contract').dialog ('destroy')


  $('.print_contract').live 'click', ->
    id = @id
    request = $.ajax
      url: 'contracts/' + id
      type: 'PUT'
      data: $('.contract_form').find('*').serialize()
      success: ->
        window.open 'contracts/' + id, '_blank'
    request.fail (xhr,satus,error) ->
      alert "Fail!"
      show_respond(xhr)




  $('.update_contract').live 'click', ->
    id = @id
    $.ajax
      url: 'contracts/' + id
      type: 'PUT'
      data: $('.contract_form').find('*').serialize()
      complete: (html)->
        show_respond(html)

  $(".button.proposal").live 'click', ->
    $(".new_proposal").dialog "open"

  $(".button.checkin").live 'click', ->
    id = @id
    $.ajax
      url: 'checkins/new?car=' + id
      complete: (html) ->
        $('.checkin_form').html html.responseText

        $(".new_checkin").dialog
          autoOpen: false
          hide: "explode"
          modal: true
          width: 700
          close: ->
           $(".new_checkin").dialog( "destroy" )
           $(".new_checkin").remove()

        $(".new_checkin").dialog "open"

        id = $(".new_checkin")[0].id
        settings =
          flash_url: "/assets/swfupload.swf"
          upload_url: "upload"
          file_size_limit: '100 MB'
          post_params:
            car: id
          button_image_url: "assets/images/TestImageNoText_65x29.png"
          button_width: "100"
          button_height: "29"
          button_placeholder_id: "spanButtonPlaceHolder"
          button_text: "<span class=\"theFont\">Загрузить</strong></span>"
          button_text_style: ".theFont { font-size: 18;font-family: Lucida Grande, Lucida Sans, Arial }"
          button_text_left_padding: 12
          button_text_top_padding: 3
          custom_settings:
            progressTarget: "fsUploadProgress"


          file_queued_handler : fileQueued
          file_queue_error_handler : fileQueueError
          file_dialog_complete_handler : fileDialogComplete
          upload_start_handler : uploadStart
          upload_progress_handler : uploadProgress
          upload_error_handler : uploadError
          upload_success_handler : uploadSuccess
          upload_complete_handler : uploadComplete
          queue_complete_handler : queueComplete

        swfu = new SWFUpload(settings)

  $('.update_checkin').live 'click', ->
    id = this.id
    $.ajax
      type: 'PUT'
      url: 'checkins/' + id
      data: $('.checkin_form').find('input[type=checkbox], textarea').serialize()
      complete: (html) ->
        $('.new_checkin').dialog 'close'
        show_respond(html)

  $(".add").click ->
    $(".new_car").dialog "open"
    $('#car_model_id').combobox()
    $('#car_person_id').combobox()
    $('#car_vin').mask("WD******9****9999")
    false


  $(".filter[type='checkbox']").live "change", ->
    $.ajax
      url: "cars.js"
      data: $('.filters').find('*').serialize()
      complete: (html) ->
        $(".cars").html html.responseText

  $("#clear_filters").live 'click', ->
    $(".filters input").each ->
      @value = ""

  $('.car').live 'click', ->
    $(".new_checkin").remove()
    id = this.id
    $.ajax
      url: "cars/" + id + '/info'
      complete: (html) ->
        $('.top-left').html html.responseText
        $('.button.contract').remove()
        $('.button.proposal').remove()
        $('.button.checkin').remove()

        $('.controls').append ('<a href=\'#\' class=\"button checkin\" id=\"' + id + '\">приемка</a>')
        $('.controls').append ('<a href=\'#\' class=\"button proposal\" id=\"' + id + '\">предложение</a>')
        $('.controls').append ('<a href=\'#\' class=\"button contract\" id=\"' + id + '\">контракт</a>')


  $('.car').live 'dblclick',  ->
    $.ajax
      url: "cars/" + @id + '/edit'
      complete: (html) ->
        $('.respond').html html.responseText

        $('#car_person_id').combobox()

        $('.car_form input#car_arrival').datepicker
          changeYear: 'true'
          changeMonth: 'true'

        $(".respond").dialog
          autoOpen: false
          hide: "explode"
          modal: true
          width: 700
          close: ->
            $(".respond").dialog( "destroy" )


        $(".respond").dialog 'open'
        $('.car_edit_cancel').click ->
          $('.respond').dialog ('destroy')

  $('.control_button#ok').click ->
    $.ajax
      url: 'cars.json'
      type: "POST"
      data: $('.new_car').find('*').serialize()
      success: (new_car) ->
        $(".new_car").dialog "close"
        location.reload
      error: (errors) ->
        messages = JSON.parse(errors.responseText)
        $('.errors').empty()
        for key of messages
          $('.errors').append "<div class='error'>" + messages[key] + '</div>'




  $(document).live 'keyup', (e) ->
    isCtrl = e.ctrlKey
    if isCtrl == true
      if e.keyCode is 38
        $('.mid-box').scrollTop(0)
      if e.keyCode is 40
        $('.mid-box').scrollTop($('.mid-box')[0].scrollHeight)


  $("#download_state").live 'click', ->
    $.ajax
      url: 'upload/1/state'
      complete: (html) ->
        show_respond(html)

        settings =
          flash_url: "/assets/swfupload.swf"
          upload_url: "upload/1/state"
          file_size_limit: '100 MB'
          assume_success_timeout: 90
          button_image_url: "assets/images/TestImageNoText_65x29.png"
          button_width: "100"
          button_height: "29"
          button_placeholder_id: "spanButtonPlaceHolder"
          button_text: "<span class=\"theFont\">Загрузить</strong></span>"
          button_text_style: ".theFont { font-size: 18;font-family: Lucida Grande, Lucida Sans, Arial }"
          button_text_left_padding: 12
          button_text_top_padding: 3
          custom_settings:
            progressTarget: "fsUploadProgress"

          file_queued_handler : fileQueued
          file_queue_error_handler : fileQueueError
          file_dialog_complete_handler : fileDialogComplete
          upload_start_handler : uploadStart
          upload_progress_handler : uploadProgress
          upload_error_handler : uploadError
          upload_success_handler : uploadSuccess
          upload_complete_handler : uploadComplete
          queue_complete_handler : queueComplete

        swfu = new SWFUpload(settings)

  $(".button.proposal").live 'click', ->
    id = @id
    $.ajax
      url: '/cars/' + id + '/proposals/new'
      complete: (html) ->
        prepare_respond(html)
        $('#proposal_person_id').combobox()
        $('.print_proposal').live 'click', ->
          request = $.ajax
            url: 'cars/' + id + '/proposals'
            type: 'POST'
            data: $('.proposal_form').find('input, select').serialize()
            success:(html) ->
              alert (html)
              window.open 'cars/' + id + '/proposals/' + html, '_blank'
          request.fail (xhr,satus,error) ->
            alert "Fail!"
            show_respond(xhr)

        open_respond()




