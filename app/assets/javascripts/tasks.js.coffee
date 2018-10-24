# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  console.log("reasssdsddssy")
  $("#task_task_type_id").on "change", ->
    console.log("hi")
    console.log($('#task_task_type_id option:selected').val())
    if $('#task_task_type_id option:selected').val() == "1"
      $('#wc_task').show()
    else
      $('#wc_task').hide()


