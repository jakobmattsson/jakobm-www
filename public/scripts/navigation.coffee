$(document).ready ->

  mobileMaxWidth = 760

  initMobileNav = ->
    $('button.close, .nav a.logo').click (event) ->
      event.preventDefault()
    $('.nav p a').click (event) ->
      event.preventDefault()
      $('.content').show()
      pageScrollPos = $('.nav').height()
      $('html, body').animate({scrollTop: pageScrollPos}, 300)

    $(window).scroll ->
      if $(this).scrollTop() > ($('.nav').height() - 10)
        $('.scroll-to-top').show()
      else
        $('.scroll-to-top').hide()

    $('.scroll-to-top').click ->
      $('html, body').animate({scrollTop: 0}, 300)
      return false

  wipeMobileNav = ->
    $('button.close, .nav a.logo').off('click')
    $('.nav p a').off('click')
    $(window).scroll -> null
    $('.scroll-to-top').off('click')

  initLaptopNav = ->
    $('button.close, .nav a.logo').click (event) ->
      event.preventDefault()
      $('.content').hide()
      window.scrollTo(0, 0)
      $('.nav').removeClass('collapsed')
    $('.nav p a').click (event) ->
      event.preventDefault()
      $('.content').show()
      $('.nav').addClass('collapsed')

  wipeLaptopNav = ->
    $('button.close, .nav a.logo').off('click')
    $('.nav p a').off('click')

  updateResponsiveNav = do ->
    screenIsMobile = window.innerWidth <= mobileMaxWidth
    if screenIsMobile
      initMobileNav()
    else
      initLaptopNav()
    ->
      if screenIsMobile and window.innerWidth > mobileMaxWidth
        wipeMobileNav()
        initLaptopNav()
        screenIsMobile = false
      else if !screenIsMobile and window.innerWidth <= mobileMaxWidth
        wipeLaptopNav()
        initMobileNav()
        screenIsMobile = true


  updateResponsiveNav()
  $(window).resize ->
    updateResponsiveNav()

