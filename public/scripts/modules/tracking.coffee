exports.dependsOn = ['$', 'tools', 'loadScript', 'document', 'unilytics']
exports.execute = ({ $, tools, loadScript, document, unilytics }) ->

  {toArray} = tools

  $('.social-links a').each ->
    unilytics.trackLink(@, 'Clicked social link', { target: $(@).attr('href') })

  $('.mini-cv a').each ->
    unilytics.trackLink(@, 'Clicked employee link', { target: $(@).attr('href') })

  toArray(document.querySelectorAll('a.close')).forEach (node) ->
    node.addEventListener 'click', ->
      unilytics.track('Clicked close button')

  toArray(document.querySelectorAll('a.logo')).forEach (node) ->
    node.addEventListener 'click', ->
      unilytics.track('Clicked bowtie button')

  toArray(document.querySelectorAll('.nav')).forEach (node) ->
    node.addEventListener 'click', (e) ->
      if (e.target || e.srcElement).tagName != 'A' # .target for standard, .srcElement for IE
        unilytics.track('Clicked navigator area')
