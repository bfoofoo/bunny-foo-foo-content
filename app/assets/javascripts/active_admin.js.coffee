#= require jquery
#= require jquery_ujs
#= require sweetalert
#= require active_admin/base

$ ->
  $(document).on "ajax:beforeSend", ".builder_action", (event, jqxhr, settings, exception) ->
    $('.builder_action').attr('disabled', true)
    $('.builder_action').addClass('disabled')

  $(document).on "ajax:error", ".builder_action", (event, jqxhr, settings, exception) ->
    $('.builder_action').attr('disabled', false)
    $('.builder_action').removeClass('disabled')
    console.log jqxhr
    if jqxhr.errors && jqxhr.errors.length
      sweetAlert("Error", jqxhr.errors.join(), "warning")
    else
      sweetAlert("Success")



  $(document).on "ajax:success", ".builder_action", (event, jqxhr, settings, exception) ->
    $('.builder_action').attr('disabled', false)
    $('.builder_action').removeClass('disabled')
    console.log jqxhr
    if jqxhr.errors && jqxhr.errors.length
      sweetAlert("Error", jqxhr.errors.join(), "warning")
    else
      sweetAlert("Success")
