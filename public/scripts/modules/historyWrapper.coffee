exports.dependsOn = ['window', 'tools', 'history', 'location']
exports.execute = ({ window, tools, history, location }) ->

  hasHistoryAPI = history?

  (nameFromUrl) ->

    getCurrent = -> nameFromUrl(if hasHistoryAPI then location.pathname else location.hash)

    path = nameFromUrl(location.pathname)
    hash = nameFromUrl(location.hash)

    if hasHistoryAPI
      actual = path || hash
      location.hash = ''
      history.replaceState(null, null, '/' + actual)
    else
      actual = hash || path
      history.replaceState(null, null, '/')
      location.hash = actual



    pushState: (name) ->
      if hasHistoryAPI
        history.pushState(null, null, '/' + name)
      else
        location.hash = name

    getCurrent: getCurrent

    onPopState: (f) ->
      if hasHistoryAPI
        window.addEventListener 'popstate', ->
          f(getCurrent())
      else
        tools.notifyOnChange (-> location.hash), 10, ->
          f(getCurrent())
