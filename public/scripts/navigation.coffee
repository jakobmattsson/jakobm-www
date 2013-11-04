$(document).ready ->

  $('button.close, .nav a.logo').click (event) ->
    event.preventDefault()
    $('.content').hide();
    $('.nav').removeClass('collapsed');

  $('.nav p a').click (event) ->
    event.preventDefault()
    $('.content').show();
    $('.nav').addClass('collapsed');