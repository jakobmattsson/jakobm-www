exports.dependsOn = []
exports.execute = ->

  toArray: (arrayLike) ->
    for node in arrayLike
      node

  memoize: (f) ->
    memory = {}
    (arg) ->
      if !memory[arg]?
        memory[arg] = f(arg)
      memory[arg] = true

  notifyOnChange: (f, delay, callback) ->
    oldValue = f()
    setInterval ->
      newValue = f()
      callback() if newValue != oldValue
      oldValue = newValue
    , delay
