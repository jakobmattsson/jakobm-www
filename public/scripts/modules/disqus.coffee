exports.dependsOn = ['document', 'window', 'loadScript']
exports.execute = ({ document, window, loadScript }) ->

  loaded = false

  load: (parentNode, disqusIdentifier, disqusTitle) ->
    
    disqusUrl = 'http://www.jakobmattsson.se/' + disqusIdentifier

    if loaded
      disqusNode = document.getElementById('disqus_thread')
      parentNode.appendChild(disqusNode)

      DISQUS.reset({
        reload: true
        config: ->
          @page.identifier = disqusIdentifier
          @page.url = disqusUrl
          @page.title = disqusTitle
      })
    else
      disqusNode = document.createElement('div')
      disqusNode.id = 'disqus_thread'
      parentNode.appendChild(disqusNode)

      window.disqus_shortname = 'jakobm'
      window.disqus_identifier = disqusIdentifier
      window.disqus_title = disqusTitle
      window.disqus_url = disqusUrl

      loadScript('//' + window.disqus_shortname + '.disqus.com/embed.js')
      loaded = true
