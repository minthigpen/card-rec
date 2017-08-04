# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.pp-background').click ->
    # on click, update the background behind the card
    $('#card_container').css("background-image", "url(" + $(this).attr('data-url')+ ")")
    # make sure the current object being clicked is the only only being outlined
    $('.pp-background').removeClass('selected')
    $(this).addClass('selected')
    # pass in the data from 
    $('#match_selection').val($(this).attr('data-match-id'));

