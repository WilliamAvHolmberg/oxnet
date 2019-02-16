# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  console.log("reasssdsddssy")
  $("#task_break_condition_id").on "change", ->
    console.log("heeellloooo")
    console.log($('#task_break_condition_id option:selected').val())
    if $('#task_break_condition_id option:selected').val() == "1"
      console.log("SHOW")
      $('#time_selection').show()
    else
      $('#time_selection').hide()
    if $('#task_break_condition_id option:selected').val() == "2"
      console.log("SHOW")
      $('#level_selection').show()
    else
      $('#level_selection').hide()
    if $('#task_break_condition_id option:selected').val() == "3"
      console.log("SHOW ALL")
      $('#level_selection').show()
      $('#time_selection').show()

  $("#task_task_type_id").on "change", ->
    console.log("hi")
    console.log($('#task_task_type_id option:selected').val())
    if $('#task_task_type_id option:selected').val() == "3"
      $('#wc_task').show()
    else
      $('#wc_task').hide()
    if $('#task_task_type_id option:selected').val() == "4"
      $('#combat_task').show()
    else
      $('#combat_task').hide()
    if $('#task_task_type_id option:selected').val() == "5"
      $('#agility_task').show()
    else
      $('#agility_task').hide()
    if $('#task_task_type_id option:selected').val() == "6"
      console.log("hiquest")
      $('#quest_task').show()
    else
      $('#quest_task').hide()
    if $('#task_task_type_id option:selected').val() == "7"
      console.log("hiquest")
      $('#mining_task').show()
    else
      $('#mining_task').hide()




