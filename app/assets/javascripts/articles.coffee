# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".media > .media-body > button").click ->
    $("#comment_replied_to_id").val $(this).data('replied-to')
    location.href = "#new_comment"
