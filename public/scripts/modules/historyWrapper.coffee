exports.dependsOn = ['window', 'tools', 'history', 'location']
exports.execute = ({ window, tools, history, location }) ->

  hasHistoryAPI = history?.pushState?

  (nameFromUrl) ->

    getCurrent = -> nameFromUrl(location.pathname)

    path = nameFromUrl(location.pathname)

    if hasHistoryAPI
      history.replaceState(null, null, '/' + path)
    # else
    #   actual = hash || path
    #   # history.replaceState(null, null, '/')
    #   location.hash = actual

    pushState: (name) ->
      if hasHistoryAPI
        history.pushState(null, null, '/' + name)
      #else
      #  window.location = '/' + name

    getCurrent: getCurrent

    onPopState: (f) ->
      if hasHistoryAPI
        window.addEventListener 'popstate', ->
          f(getCurrent())
      # else
      #   tools.notifyOnChange (-> location.hash), 10, ->
      #     f(getCurrent())
