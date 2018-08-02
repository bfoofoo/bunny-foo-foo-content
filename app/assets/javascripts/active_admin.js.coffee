#= require jquery
#= require jquery_ujs
#= require sweetalert
#= require active_admin/base
#= require active_admin/sortable
#= require active_admin/base

#= require_tree ./admin

#= require highcharts
#= require highcharts/highcharts-more

#= require activeadmin/froala_editor/froala_editor.pkgd.min
#= require activeadmin/froala_editor_input
#= require highcharts-grouped-categories

$ ->
  $(document).on "ajax:beforeSend", ".builder_action", (event, jqxhr, settings, exception) ->
    $('.builder_action').attr('disabled', true)
    $('.builder_action').addClass('disabled')
    $('.builder_action .loader').addClass('active')

  $(document).on "ajax:error", ".builder_action", (event, jqxhr, settings, exception) ->
    $('.builder_action').attr('disabled', false)
    $('.builder_action').removeClass('disabled')
    $('.builder_action .loader').removeClass('active')
    console.log jqxhr
    if jqxhr.errors && jqxhr.errors.length
      sweetAlert("Error", jqxhr.errors.join(), "warning")
    else
      sweetAlert("Success")

  $(document).on "ajax:success", ".builder_action", (event, jqxhr, settings, exception) ->
    $('.builder_action').attr('disabled', false)
    $('.builder_action').removeClass('disabled')
    $('.builder_action .loader').removeClass('active')
    console.log jqxhr
    if jqxhr.errors && jqxhr.errors.length
      sweetAlert("Error", jqxhr.errors.join(), "warning")
    else
      sweetAlert("Success")
