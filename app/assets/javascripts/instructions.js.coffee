# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  console.log("readsy")
  console.log($('#instruction_instruction_type_id option:selected').val())
  $("#instruction_select").on "change", ->
    console.log("change")
    $.ajax 'get_accounts',
      type: "GET"
      dataType: "script"
      data:
        instruction_type_id: $('#instruction_instruction_type_id option:selected').val()