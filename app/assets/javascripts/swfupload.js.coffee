###
SWFUpload: http://www.swfupload.org, http://swfupload.googlecode.com

mmSWFUpload 1.0: Flash upload dialog - http://profandesign.se/swfupload/,  http://www.vinterwebb.se/

SWFUpload is (c) 2006-2007 Lars Huring, Olov Nilzén and Mammon Media and is released under the MIT License:
http://www.opensource.org/licenses/mit-license.php

SWFUpload 2 is (c) 2007-2008 Jake Roberts and is released under the MIT License:
http://www.opensource.org/licenses/mit-license.php
###

# ******************* 

# Constructor & Init  

# ******************* 
SWFUpload = undefined
if SWFUpload is `undefined`
  SWFUpload = (settings) ->
    @initSWFUpload settings
SWFUpload::initSWFUpload = (settings) ->
  try
    @customSettings = {} # A container where developers can place their own settings associated with this instance.
    @settings = settings
    @eventQueue = []
    @movieName = "SWFUpload_" + SWFUpload.movieCount++
    @movieElement = null
    
    # Setup global control tracking
    SWFUpload.instances[@movieName] = this
    
    # Load the settings.  Load the Flash movie.
    @initSettings()
    @loadFlash()
    @displayDebugInfo()
  catch ex
    delete SWFUpload.instances[@movieName]

    throw ex


# *************** 

# Static Members  

# *************** 
SWFUpload.instances = {}
SWFUpload.movieCount = 0
SWFUpload.version = "2.2.0 2009-03-25"
SWFUpload.QUEUE_ERROR =
  QUEUE_LIMIT_EXCEEDED: -100
  FILE_EXCEEDS_SIZE_LIMIT: -110
  ZERO_BYTE_FILE: -120
  INVALID_FILETYPE: -130

SWFUpload.UPLOAD_ERROR =
  HTTP_ERROR: -200
  MISSING_UPLOAD_URL: -210
  IO_ERROR: -220
  SECURITY_ERROR: -230
  UPLOAD_LIMIT_EXCEEDED: -240
  UPLOAD_FAILED: -250
  SPECIFIED_FILE_ID_NOT_FOUND: -260
  FILE_VALIDATION_FAILED: -270
  FILE_CANCELLED: -280
  UPLOAD_STOPPED: -290

SWFUpload.FILE_STATUS =
  QUEUED: -1
  IN_PROGRESS: -2
  ERROR: -3
  COMPLETE: -4
  CANCELLED: -5

SWFUpload.BUTTON_ACTION =
  SELECT_FILE: -100
  SELECT_FILES: -110
  START_UPLOAD: -120

SWFUpload.CURSOR =
  ARROW: -1
  HAND: -2

SWFUpload.WINDOW_MODE =
  WINDOW: "window"
  TRANSPARENT: "transparent"
  OPAQUE: "opaque"


# Private: takes a URL, determines if it is relative and converts to an absolute URL
# using the current site. Only processes the URL if it can, otherwise returns the URL untouched
SWFUpload.completeURL = (url) ->
  return url  if typeof (url) isnt "string" or url.match(/^https?:\/\//i) or url.match(/^\//)
  currentURL = window.location.protocol + "//" + window.location.hostname + ((if window.location.port then ":" + window.location.port else ""))
  indexSlash = window.location.pathname.lastIndexOf("/")
  if indexSlash <= 0
    path = "/"
  else
    path = window.location.pathname.substr(0, indexSlash) + "/"
  path + url #currentURL +


# ******************** 

# Instance Members  

# ******************** 

# Private: initSettings ensures that all the
# settings are set, getting a default value if one was not assigned.
SWFUpload::initSettings = ->
  @ensureDefault = (settingName, defaultValue) ->
    @settings[settingName] = (if (@settings[settingName] is `undefined`) then defaultValue else @settings[settingName])

  
  # Upload backend settings
  @ensureDefault "upload_url", ""
  @ensureDefault "preserve_relative_urls", false
  @ensureDefault "file_post_name", "Filedata"
  @ensureDefault "post_params", {}
  @ensureDefault "use_query_string", false
  @ensureDefault "requeue_on_error", false
  @ensureDefault "http_success", []
  @ensureDefault "assume_success_timeout", 0
  
  # File Settings
  @ensureDefault "file_types", "*.*"
  @ensureDefault "file_types_description", "All Files"
  @ensureDefault "file_size_limit", 0 # Default zero means "unlimited"
  @ensureDefault "file_upload_limit", 0
  @ensureDefault "file_queue_limit", 0
  
  # Flash Settings
  @ensureDefault "flash_url", "swfupload.swf"
  @ensureDefault "prevent_swf_caching", true
  
  # Button Settings
  @ensureDefault "button_image_url", ""
  @ensureDefault "button_width", 1
  @ensureDefault "button_height", 1
  @ensureDefault "button_text", ""
  @ensureDefault "button_text_style", "color: #000000; font-size: 16pt;"
  @ensureDefault "button_text_top_padding", 0
  @ensureDefault "button_text_left_padding", 0
  @ensureDefault "button_action", SWFUpload.BUTTON_ACTION.SELECT_FILES
  @ensureDefault "button_disabled", false
  @ensureDefault "button_placeholder_id", ""
  @ensureDefault "button_placeholder", null
  @ensureDefault "button_cursor", SWFUpload.CURSOR.ARROW
  @ensureDefault "button_window_mode", SWFUpload.WINDOW_MODE.WINDOW
  
  # Debug Settings
  @ensureDefault "debug", false
  @settings.debug_enabled = @settings.debug # Here to maintain v2 API
  
  # Event Handlers
  @settings.return_upload_start_handler = @returnUploadStart
  @ensureDefault "swfupload_loaded_handler", null
  @ensureDefault "file_dialog_start_handler", null
  @ensureDefault "file_queued_handler", null
  @ensureDefault "file_queue_error_handler", null
  @ensureDefault "file_dialog_complete_handler", null
  @ensureDefault "upload_start_handler", null
  @ensureDefault "upload_progress_handler", null
  @ensureDefault "upload_error_handler", null
  @ensureDefault "upload_success_handler", null
  @ensureDefault "upload_complete_handler", null
  @ensureDefault "debug_handler", @debugMessage
  @ensureDefault "custom_settings", {}
  
  # Other settings
  @customSettings = @settings.custom_settings
  
  # Update the flash url if needed
  @settings.flash_url = @settings.flash_url + ((if @settings.flash_url.indexOf("?") < 0 then "?" else "&")) + "preventswfcaching=" + new Date().getTime()  unless not @settings.prevent_swf_caching
  unless @settings.preserve_relative_urls
    
    #this.settings.flash_url = SWFUpload.completeURL(this.settings.flash_url);	// Don't need to do this one since flash doesn't look at it
    @settings.upload_url = SWFUpload.completeURL(@settings.upload_url)
    @settings.button_image_url = SWFUpload.completeURL(@settings.button_image_url)
  delete @ensureDefault


# Private: loadFlash replaces the button_placeholder element with the flash movie.
SWFUpload::loadFlash = ->
  targetElement = undefined
  tempParent = undefined
  
  # Make sure an element with the ID we are going to use doesn't already exist
  throw "ID " + @movieName + " is already in use. The Flash Object could not be added"  if document.getElementById(@movieName) isnt null
  
  # Get the element where we will be placing the flash movie
  targetElement = document.getElementById(@settings.button_placeholder_id) or @settings.button_placeholder
  throw "Could not find the placeholder element: " + @settings.button_placeholder_id  if targetElement is `undefined`
  
  # Append the container and load the flash
  tempParent = document.createElement("div")
  tempParent.innerHTML = @getFlashHTML() # Using innerHTML is non-standard but the only sensible way to dynamically add Flash in IE (and maybe other browsers)
  targetElement.parentNode.replaceChild tempParent.firstChild, targetElement
  
  # Fix IE Flash/Form bug
  window[@movieName] = @getMovieElement()  if window[@movieName] is `undefined`


# Private: getFlashHTML generates the object tag needed to embed the flash in to the document
SWFUpload::getFlashHTML = ->
  
  # Flash Satay object syntax: http://www.alistapart.com/articles/flashsatay
  ["<object id=\"", @movieName, "\" type=\"application/x-shockwave-flash\" data=\"", @settings.flash_url, "\" width=\"", @settings.button_width, "\" height=\"", @settings.button_height, "\" class=\"swfupload\">", "<param name=\"wmode\" value=\"", @settings.button_window_mode, "\" />", "<param name=\"movie\" value=\"", @settings.flash_url, "\" />", "<param name=\"quality\" value=\"high\" />", "<param name=\"menu\" value=\"false\" />", "<param name=\"allowScriptAccess\" value=\"always\" />", "<param name=\"flashvars\" value=\"" + @getFlashVars() + "\" />", "</object>"].join ""


# Private: getFlashVars builds the parameter string that will be passed
# to flash in the flashvars param.
SWFUpload::getFlashVars = ->
  
  # Build a string from the post param object
  paramString = @buildParamString()
  httpSuccessString = @settings.http_success.join(",")
  
  # Build the parameter string
  ["movieName=", encodeURIComponent(@movieName), "&amp;uploadURL=", encodeURIComponent(@settings.upload_url), "&amp;useQueryString=", encodeURIComponent(@settings.use_query_string), "&amp;requeueOnError=", encodeURIComponent(@settings.requeue_on_error), "&amp;httpSuccess=", encodeURIComponent(httpSuccessString), "&amp;assumeSuccessTimeout=", encodeURIComponent(@settings.assume_success_timeout), "&amp;params=", encodeURIComponent(paramString), "&amp;filePostName=", encodeURIComponent(@settings.file_post_name), "&amp;fileTypes=", encodeURIComponent(@settings.file_types), "&amp;fileTypesDescription=", encodeURIComponent(@settings.file_types_description), "&amp;fileSizeLimit=", encodeURIComponent(@settings.file_size_limit), "&amp;fileUploadLimit=", encodeURIComponent(@settings.file_upload_limit), "&amp;fileQueueLimit=", encodeURIComponent(@settings.file_queue_limit), "&amp;debugEnabled=", encodeURIComponent(@settings.debug_enabled), "&amp;buttonImageURL=", encodeURIComponent(@settings.button_image_url), "&amp;buttonWidth=", encodeURIComponent(@settings.button_width), "&amp;buttonHeight=", encodeURIComponent(@settings.button_height), "&amp;buttonText=", encodeURIComponent(@settings.button_text), "&amp;buttonTextTopPadding=", encodeURIComponent(@settings.button_text_top_padding), "&amp;buttonTextLeftPadding=", encodeURIComponent(@settings.button_text_left_padding), "&amp;buttonTextStyle=", encodeURIComponent(@settings.button_text_style), "&amp;buttonAction=", encodeURIComponent(@settings.button_action), "&amp;buttonDisabled=", encodeURIComponent(@settings.button_disabled), "&amp;buttonCursor=", encodeURIComponent(@settings.button_cursor)].join ""


# Public: getMovieElement retrieves the DOM reference to the Flash element added by SWFUpload
# The element is cached after the first lookup
SWFUpload::getMovieElement = ->
  @movieElement = document.getElementById(@movieName)  if @movieElement is `undefined`
  throw "Could not find Flash element"  if @movieElement is null
  @movieElement


# Private: buildParamString takes the name/value pairs in the post_params setting object
# and joins them up in to a string formatted "name=value&amp;name=value"
SWFUpload::buildParamString = ->
  postParams = @settings.post_params
  paramStringPairs = []
  if typeof (postParams) is "object"
    for name of postParams
      paramStringPairs.push encodeURIComponent(name.toString()) + "=" + encodeURIComponent(postParams[name].toString())  if postParams.hasOwnProperty(name)
  paramStringPairs.join "&amp;"


# Public: Used to remove a SWFUpload instance from the page. This method strives to remove
# all references to the SWF, and other objects so memory is properly freed.
# Returns true if everything was destroyed. Returns a false if a failure occurs leaving SWFUpload in an inconsistant state.
# Credits: Major improvements provided by steffen
SWFUpload::destroy = ->
  try
    
    # Make sure Flash is done before we try to remove it
    @cancelUpload null, false
    
    # Remove the SWFUpload DOM nodes
    movieElement = null
    movieElement = @getMovieElement()
    if movieElement and typeof (movieElement.CallFunction) is "unknown" # We only want to do this in IE
      # Loop through all the movie's properties and remove all function references (DOM/JS IE 6/7 memory leak workaround)
      for i of movieElement
        try
          movieElement[i] = null  if typeof (movieElement[i]) is "function"
      
      # Remove the Movie Element from the page
      try
        movieElement.parentNode.removeChild movieElement
    
    # Remove IE form fix reference
    window[@movieName] = null
    
    # Destroy other references
    SWFUpload.instances[@movieName] = null
    delete SWFUpload.instances[@movieName]

    @movieElement = null
    @settings = null
    @customSettings = null
    @eventQueue = null
    @movieName = null
    return true
  catch ex2
    return false


# Public: displayDebugInfo prints out settings and configuration
# information about this SWFUpload instance.
# This function (and any references to it) can be deleted when placing
# SWFUpload in production.
SWFUpload::displayDebugInfo = ->
  @debug ["---SWFUpload Instance Info---\n", "Version: ", SWFUpload.version, "\n", "Movie Name: ", @movieName, "\n", "Settings:\n", "\t", "upload_url:               ", @settings.upload_url, "\n", "\t", "flash_url:                ", @settings.flash_url, "\n", "\t", "use_query_string:         ", @settings.use_query_string.toString(), "\n", "\t", "requeue_on_error:         ", @settings.requeue_on_error.toString(), "\n", "\t", "http_success:             ", @settings.http_success.join(", "), "\n", "\t", "assume_success_timeout:   ", @settings.assume_success_timeout, "\n", "\t", "file_post_name:           ", @settings.file_post_name, "\n", "\t", "post_params:              ", @settings.post_params.toString(), "\n", "\t", "file_types:               ", @settings.file_types, "\n", "\t", "file_types_description:   ", @settings.file_types_description, "\n", "\t", "file_size_limit:          ", @settings.file_size_limit, "\n", "\t", "file_upload_limit:        ", @settings.file_upload_limit, "\n", "\t", "file_queue_limit:         ", @settings.file_queue_limit, "\n", "\t", "debug:                    ", @settings.debug.toString(), "\n", "\t", "prevent_swf_caching:      ", @settings.prevent_swf_caching.toString(), "\n", "\t", "button_placeholder_id:    ", @settings.button_placeholder_id.toString(), "\n", "\t", "button_placeholder:       ", ((if @settings.button_placeholder then "Set" else "Not Set")), "\n", "\t", "button_image_url:         ", @settings.button_image_url.toString(), "\n", "\t", "button_width:             ", @settings.button_width.toString(), "\n", "\t", "button_height:            ", @settings.button_height.toString(), "\n", "\t", "button_text:              ", @settings.button_text.toString(), "\n", "\t", "button_text_style:        ", @settings.button_text_style.toString(), "\n", "\t", "button_text_top_padding:  ", @settings.button_text_top_padding.toString(), "\n", "\t", "button_text_left_padding: ", @settings.button_text_left_padding.toString(), "\n", "\t", "button_action:            ", @settings.button_action.toString(), "\n", "\t", "button_disabled:          ", @settings.button_disabled.toString(), "\n", "\t", "custom_settings:          ", @settings.custom_settings.toString(), "\n", "Event Handlers:\n", "\t", "swfupload_loaded_handler assigned:  ", (typeof @settings.swfupload_loaded_handler is "function").toString(), "\n", "\t", "file_dialog_start_handler assigned: ", (typeof @settings.file_dialog_start_handler is "function").toString(), "\n", "\t", "file_queued_handler assigned:       ", (typeof @settings.file_queued_handler is "function").toString(), "\n", "\t", "file_queue_error_handler assigned:  ", (typeof @settings.file_queue_error_handler is "function").toString(), "\n", "\t", "upload_start_handler assigned:      ", (typeof @settings.upload_start_handler is "function").toString(), "\n", "\t", "upload_progress_handler assigned:   ", (typeof @settings.upload_progress_handler is "function").toString(), "\n", "\t", "upload_error_handler assigned:      ", (typeof @settings.upload_error_handler is "function").toString(), "\n", "\t", "upload_success_handler assigned:    ", (typeof @settings.upload_success_handler is "function").toString(), "\n", "\t", "upload_complete_handler assigned:   ", (typeof @settings.upload_complete_handler is "function").toString(), "\n", "\t", "debug_handler assigned:             ", (typeof @settings.debug_handler is "function").toString(), "\n"].join("")


# Note: addSetting and getSetting are no longer used by SWFUpload but are included
#	the maintain v2 API compatibility
#

# Public: (Deprecated) addSetting adds a setting value. If the value given is undefined or null then the default_value is used.
SWFUpload::addSetting = (name, value, default_value) ->
  if value is `undefined`
    @settings[name] = default_value
  else
    @settings[name] = value


# Public: (Deprecated) getSetting gets a setting. Returns an empty string if the setting was not found.
SWFUpload::getSetting = (name) ->
  return @settings[name]  unless @settings[name] is `undefined`
  ""


# Private: callFlash handles function calls made to the Flash element.
# Calls are made with a setTimeout for some functions to work around
# bugs in the ExternalInterface library.
SWFUpload::callFlash = (functionName, argumentArray) ->
  argumentArray = argumentArray or []
  movieElement = @getMovieElement()
  returnValue = undefined
  returnString = undefined
  
  # Flash's method if calling ExternalInterface methods (code adapted from MooTools).
  try
    returnString = movieElement.CallFunction("<invoke name=\"" + functionName + "\" returntype=\"javascript\">" + __flash__argumentsToXML(argumentArray, 0) + "</invoke>")
    returnValue = eval_(returnString)
  catch ex
    throw "Call to " + functionName + " failed"
  
  # Unescape file post param values
  returnValue = @unescapeFilePostParams(returnValue)  if returnValue isnt `undefined` and typeof returnValue.post is "object"
  returnValue


# *****************************
#	-- Flash control methods --
#	Your UI should use these
#	to operate SWFUpload
#   ***************************** 

# WARNING: this function does not work in Flash Player 10
# Public: selectFile causes a File Selection Dialog window to appear.  This
# dialog only allows 1 file to be selected.
SWFUpload::selectFile = ->
  @callFlash "SelectFile"


# WARNING: this function does not work in Flash Player 10
# Public: selectFiles causes a File Selection Dialog window to appear/ This
# dialog allows the user to select any number of files
# Flash Bug Warning: Flash limits the number of selectable files based on the combined length of the file names.
# If the selection name length is too long the dialog will fail in an unpredictable manner.  There is no work-around
# for this bug.
SWFUpload::selectFiles = ->
  @callFlash "SelectFiles"


# Public: startUpload starts uploading the first file in the queue unless
# the optional parameter 'fileID' specifies the ID 
SWFUpload::startUpload = (fileID) ->
  @callFlash "StartUpload", [fileID]


# Public: cancelUpload cancels any queued file.  The fileID parameter may be the file ID or index.
# If you do not specify a fileID the current uploading file or first file in the queue is cancelled.
# If you do not want the uploadError event to trigger you can specify false for the triggerErrorEvent parameter.
SWFUpload::cancelUpload = (fileID, triggerErrorEvent) ->
  triggerErrorEvent = true  if triggerErrorEvent isnt false
  @callFlash "CancelUpload", [fileID, triggerErrorEvent]


# Public: stopUpload stops the current upload and requeues the file at the beginning of the queue.
# If nothing is currently uploading then nothing happens.
SWFUpload::stopUpload = ->
  @callFlash "StopUpload"


# ************************
# * Settings methods
# *   These methods change the SWFUpload settings.
# *   SWFUpload settings should not be changed directly on the settings object
# *   since many of the settings need to be passed to Flash in order to take
# *   effect.
# * *********************** 

# Public: getStats gets the file statistics object.
SWFUpload::getStats = ->
  @callFlash "GetStats"


# Public: setStats changes the SWFUpload statistics.  You shouldn't need to 
# change the statistics but you can.  Changing the statistics does not
# affect SWFUpload accept for the successful_uploads count which is used
# by the upload_limit setting to determine how many files the user may upload.
SWFUpload::setStats = (statsObject) ->
  @callFlash "SetStats", [statsObject]


# Public: getFile retrieves a File object by ID or Index.  If the file is
# not found then 'null' is returned.
SWFUpload::getFile = (fileID) ->
  if typeof (fileID) is "number"
    @callFlash "GetFileByIndex", [fileID]
  else
    @callFlash "GetFile", [fileID]


# Public: addFileParam sets a name/value pair that will be posted with the
# file specified by the Files ID.  If the name already exists then the
# exiting value will be overwritten.
SWFUpload::addFileParam = (fileID, name, value) ->
  @callFlash "AddFileParam", [fileID, name, value]


# Public: removeFileParam removes a previously set (by addFileParam) name/value
# pair from the specified file.
SWFUpload::removeFileParam = (fileID, name) ->
  @callFlash "RemoveFileParam", [fileID, name]


# Public: setUploadUrl changes the upload_url setting.
SWFUpload::setUploadURL = (url) ->
  @settings.upload_url = url.toString()
  @callFlash "SetUploadURL", [url]


# Public: setPostParams changes the post_params setting
SWFUpload::setPostParams = (paramsObject) ->
  @settings.post_params = paramsObject
  @callFlash "SetPostParams", [paramsObject]


# Public: addPostParam adds post name/value pair.  Each name can have only one value.
SWFUpload::addPostParam = (name, value) ->
  @settings.post_params[name] = value
  @callFlash "SetPostParams", [@settings.post_params]


# Public: removePostParam deletes post name/value pair.
SWFUpload::removePostParam = (name) ->
  delete @settings.post_params[name]

  @callFlash "SetPostParams", [@settings.post_params]


# Public: setFileTypes changes the file_types setting and the file_types_description setting
SWFUpload::setFileTypes = (types, description) ->
  @settings.file_types = types
  @settings.file_types_description = description
  @callFlash "SetFileTypes", [types, description]


# Public: setFileSizeLimit changes the file_size_limit setting
SWFUpload::setFileSizeLimit = (fileSizeLimit) ->
  @settings.file_size_limit = fileSizeLimit
  @callFlash "SetFileSizeLimit", [fileSizeLimit]


# Public: setFileUploadLimit changes the file_upload_limit setting
SWFUpload::setFileUploadLimit = (fileUploadLimit) ->
  @settings.file_upload_limit = fileUploadLimit
  @callFlash "SetFileUploadLimit", [fileUploadLimit]


# Public: setFileQueueLimit changes the file_queue_limit setting
SWFUpload::setFileQueueLimit = (fileQueueLimit) ->
  @settings.file_queue_limit = fileQueueLimit
  @callFlash "SetFileQueueLimit", [fileQueueLimit]


# Public: setFilePostName changes the file_post_name setting
SWFUpload::setFilePostName = (filePostName) ->
  @settings.file_post_name = filePostName
  @callFlash "SetFilePostName", [filePostName]


# Public: setUseQueryString changes the use_query_string setting
SWFUpload::setUseQueryString = (useQueryString) ->
  @settings.use_query_string = useQueryString
  @callFlash "SetUseQueryString", [useQueryString]


# Public: setRequeueOnError changes the requeue_on_error setting
SWFUpload::setRequeueOnError = (requeueOnError) ->
  @settings.requeue_on_error = requeueOnError
  @callFlash "SetRequeueOnError", [requeueOnError]


# Public: setHTTPSuccess changes the http_success setting
SWFUpload::setHTTPSuccess = (http_status_codes) ->
  http_status_codes = http_status_codes.replace(" ", "").split(",")  if typeof http_status_codes is "string"
  @settings.http_success = http_status_codes
  @callFlash "SetHTTPSuccess", [http_status_codes]


# Public: setHTTPSuccess changes the http_success setting
SWFUpload::setAssumeSuccessTimeout = (timeout_seconds) ->
  @settings.assume_success_timeout = timeout_seconds
  @callFlash "SetAssumeSuccessTimeout", [timeout_seconds]


# Public: setDebugEnabled changes the debug_enabled setting
SWFUpload::setDebugEnabled = (debugEnabled) ->
  @settings.debug_enabled = debugEnabled
  @callFlash "SetDebugEnabled", [debugEnabled]


# Public: setButtonImageURL loads a button image sprite
SWFUpload::setButtonImageURL = (buttonImageURL) ->
  buttonImageURL = ""  if buttonImageURL is `undefined`
  @settings.button_image_url = buttonImageURL
  @callFlash "SetButtonImageURL", [buttonImageURL]


# Public: setButtonDimensions resizes the Flash Movie and button
SWFUpload::setButtonDimensions = (width, height) ->
  @settings.button_width = width
  @settings.button_height = height
  movie = @getMovieElement()
  unless movie is `undefined`
    movie.style.width = width + "px"
    movie.style.height = height + "px"
  @callFlash "SetButtonDimensions", [width, height]


# Public: setButtonText Changes the text overlaid on the button
SWFUpload::setButtonText = (html) ->
  @settings.button_text = html
  @callFlash "SetButtonText", [html]


# Public: setButtonTextPadding changes the top and left padding of the text overlay
SWFUpload::setButtonTextPadding = (left, top) ->
  @settings.button_text_top_padding = top
  @settings.button_text_left_padding = left
  @callFlash "SetButtonTextPadding", [left, top]


# Public: setButtonTextStyle changes the CSS used to style the HTML/Text overlaid on the button
SWFUpload::setButtonTextStyle = (css) ->
  @settings.button_text_style = css
  @callFlash "SetButtonTextStyle", [css]


# Public: setButtonDisabled disables/enables the button
SWFUpload::setButtonDisabled = (isDisabled) ->
  @settings.button_disabled = isDisabled
  @callFlash "SetButtonDisabled", [isDisabled]


# Public: setButtonAction sets the action that occurs when the button is clicked
SWFUpload::setButtonAction = (buttonAction) ->
  @settings.button_action = buttonAction
  @callFlash "SetButtonAction", [buttonAction]


# Public: setButtonCursor changes the mouse cursor displayed when hovering over the button
SWFUpload::setButtonCursor = (cursor) ->
  @settings.button_cursor = cursor
  @callFlash "SetButtonCursor", [cursor]


# *******************************
#	Flash Event Interfaces
#	These functions are used by Flash to trigger the various
#	events.
#	
#	All these functions a Private.
#	
#	Because the ExternalInterface library is buggy the event calls
#	are added to a queue and the queue then executed by a setTimeout.
#	This ensures that events are executed in a determinate order and that
#	the ExternalInterface bugs are avoided.
#******************************* 
SWFUpload::queueEvent = (handlerName, argumentArray) ->
  
  # Warning: Don't call this.debug inside here or you'll create an infinite loop
  if argumentArray is `undefined`
    argumentArray = []
  else argumentArray = [argumentArray]  unless argumentArray instanceof Array
  self = this
  if typeof @settings[handlerName] is "function"
    
    # Queue the event
    @eventQueue.push ->
      @settings[handlerName].apply this, argumentArray

    
    # Execute the next queued event
    setTimeout (->
      self.executeNextEvent()
    ), 0
  else throw "Event handler " + handlerName + " is unknown or is not a function"  if @settings[handlerName] isnt null


# Private: Causes the next event in the queue to be executed.  Since events are queued using a setTimeout
# we must queue them in order to garentee that they are executed in order.
SWFUpload::executeNextEvent = ->
  
  # Warning: Don't call this.debug inside here or you'll create an infinite loop
  f = (if @eventQueue then @eventQueue.shift() else null)
  f.apply this  if typeof (f) is "function"


# Private: unescapeFileParams is part of a workaround for a flash bug where objects passed through ExternalInterface cannot have
# properties that contain characters that are not valid for JavaScript identifiers. To work around this
# the Flash Component escapes the parameter names and we must unescape again before passing them along.
SWFUpload::unescapeFilePostParams = (file) ->
  reg = /[$]([0-9a-f]{4})/i
  unescapedPost = {}
  uk = undefined
  unless file is `undefined`
    for k of file.post
      if file.post.hasOwnProperty(k)
        uk = k
        match = undefined
        uk = uk.replace(match[0], String.fromCharCode(parseInt("0x" + match[1], 16)))  while (match = reg.exec(uk)) isnt null
        unescapedPost[uk] = file.post[k]
    file.post = unescapedPost
  file


# Private: Called by Flash to see if JS can call in to Flash (test if External Interface is working)
SWFUpload::testExternalInterface = ->
  try
    return @callFlash("TestExternalInterface")
  catch ex
    return false


# Private: This event is called by Flash when it has finished loading. Don't modify this.
# Use the swfupload_loaded_handler event setting to execute custom code when SWFUpload has loaded.
SWFUpload::flashReady = ->
  
  # Check that the movie element is loaded correctly with its ExternalInterface methods defined
  movieElement = @getMovieElement()
  unless movieElement
    @debug "Flash called back ready but the flash movie can't be found."
    return
  @cleanUp movieElement
  @queueEvent "swfupload_loaded_handler"


# Private: removes Flash added fuctions to the DOM node to prevent memory leaks in IE.
# This function is called by Flash each time the ExternalInterface functions are created.
SWFUpload::cleanUp = (movieElement) ->
  
  # Pro-actively unhook all the Flash functions
  try
    if @movieElement and typeof (movieElement.CallFunction) is "unknown" # We only want to do this in IE
      @debug "Removing Flash functions hooks (this should only run in IE and should prevent memory leaks)"
      for key of movieElement
        try
          movieElement[key] = null  if typeof (movieElement[key]) is "function"
  
  # Fix Flashes own cleanup code so if the SWFMovie was removed from the page
  # it doesn't display errors.
  window["__flash__removeCallback"] = (instance, name) ->
    try
      instance[name] = null  if instance


# This is a chance to do something before the browse window opens 
SWFUpload::fileDialogStart = ->
  @queueEvent "file_dialog_start_handler"


# Called when a file is successfully added to the queue. 
SWFUpload::fileQueued = (file) ->
  file = @unescapeFilePostParams(file)
  @queueEvent "file_queued_handler", file


# Handle errors that occur when an attempt to queue a file fails. 
SWFUpload::fileQueueError = (file, errorCode, message) ->
  file = @unescapeFilePostParams(file)
  @queueEvent "file_queue_error_handler", [file, errorCode, message]


# Called after the file dialog has closed and the selected files have been queued.
#	You could call startUpload here if you want the queued files to begin uploading immediately. 
SWFUpload::fileDialogComplete = (numFilesSelected, numFilesQueued, numFilesInQueue) ->
  @queueEvent "file_dialog_complete_handler", [numFilesSelected, numFilesQueued, numFilesInQueue]

SWFUpload::uploadStart = (file) ->
  file = @unescapeFilePostParams(file)
  @queueEvent "return_upload_start_handler", file

SWFUpload::returnUploadStart = (file) ->
  returnValue = undefined
  if typeof @settings.upload_start_handler is "function"
    file = @unescapeFilePostParams(file)
    returnValue = @settings.upload_start_handler.call(this, file)
  else throw "upload_start_handler must be a function"  unless @settings.upload_start_handler is `undefined`
  
  # Convert undefined to true so if nothing is returned from the upload_start_handler it is
  # interpretted as 'true'.
  returnValue = true  if returnValue is `undefined`
  returnValue = !!returnValue
  @callFlash "ReturnUploadStart", [returnValue]

SWFUpload::uploadProgress = (file, bytesComplete, bytesTotal) ->
  file = @unescapeFilePostParams(file)
  @queueEvent "upload_progress_handler", [file, bytesComplete, bytesTotal]

SWFUpload::uploadError = (file, errorCode, message) ->
  file = @unescapeFilePostParams(file)
  @queueEvent "upload_error_handler", [file, errorCode, message]

SWFUpload::uploadSuccess = (file, serverData, responseReceived) ->
  file = @unescapeFilePostParams(file)
  @queueEvent "upload_success_handler", [file, serverData, responseReceived]

SWFUpload::uploadComplete = (file) ->
  file = @unescapeFilePostParams(file)
  @queueEvent "upload_complete_handler", file


# Called by SWFUpload JavaScript and Flash functions when debug is enabled. By default it writes messages to the
#   internal debug console.  You can override this event and have messages written where you want. 
SWFUpload::debug = (message) ->
  @queueEvent "debug_handler", message


# **********************************
#	Debug Console
#	The debug console is a self contained, in page location
#	for debug message to be sent.  The Debug Console adds
#	itself to the body if necessary.
#
#	The console is automatically scrolled as messages appear.
#	
#	If you are using your own debug handler or when you deploy to production and
#	have debug disabled you can remove these functions to reduce the file size
#	and complexity.
#********************************** 

# Private: debugMessage is the default debug_handler.  If you want to print debug messages
# call the debug() function.  When overriding the function your own function should
# check to see if the debug setting is true before outputting debug information.
SWFUpload::debugMessage = (message) ->
  if @settings.debug
    exceptionMessage = undefined
    exceptionValues = []
    
    # Check for an exception object and print it nicely
    if typeof message is "object" and typeof message.name is "string" and typeof message.message is "string"
      for key of message
        exceptionValues.push key + ": " + message[key]  if message.hasOwnProperty(key)
      exceptionMessage = exceptionValues.join("\n") or ""
      exceptionValues = exceptionMessage.split("\n")
      exceptionMessage = "EXCEPTION: " + exceptionValues.join("\nEXCEPTION: ")
      SWFUpload.Console.writeLine exceptionMessage
    else
      SWFUpload.Console.writeLine message

SWFUpload.Console = {}
SWFUpload.Console.writeLine = (message) ->
  console = undefined
  documentForm = undefined
  try
    console = document.getElementById("SWFUpload_Console")
    unless console
      documentForm = document.createElement("form")
      document.getElementsByTagName("body")[0].appendChild documentForm
      console = document.createElement("textarea")
      console.id = "SWFUpload_Console"
      console.style.fontFamily = "monospace"
      console.setAttribute "wrap", "off"
      console.wrap = "off"
      console.style.overflow = "auto"
      console.style.width = "700px"
      console.style.height = "350px"
      console.style.margin = "5px"
      documentForm.appendChild console
    console.value += message + "\n"
    console.scrollTop = console.scrollHeight - console.clientHeight
  catch ex
    alert "Exception: " + ex.name + " Message: " + ex.message