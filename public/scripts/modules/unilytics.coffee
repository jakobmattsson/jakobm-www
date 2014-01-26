exports.dependsOn = ['location', 'analytics']
exports.execute = ({ location, analytics }) ->

  ignoredHosts = ['localhost', 'staging.jakobm.com']

  log = (args...) ->
    if console?.log?
      console.log(args...)

  if ignoredHosts.some((host) -> host == location.hostname) then {
    trackLink: (node, args...) ->
      node.addEventListener 'click', (e) ->
        log("TrackLink", args...)
    track: (args...) ->
      log("Track", args...)
    page: (args...) ->
      log("Page", args...)
  } else analytics
