exports.execute = ({ document }) ->

  (url) ->
    node = document.createElement('script')
    node.setAttribute('type', 'text/javascript')
    node.setAttribute('src', url)
    node.async = true
    document.body.insertBefore(node)
