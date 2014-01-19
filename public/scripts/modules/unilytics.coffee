exports.dependsOn = ['location', 'analytics']
exports.execute = ({ location, analytics }) ->
  if location.hostname == 'localhost' then {
    trackLink: (node, args...) ->
      node.addEventListener 'click', (e) ->
        console.log("TrackLink", args...)
    track: (args...) ->
      console.log("Track", args...)
    page: (args...) ->
      console.log("Page", args...)
  } else analytics
