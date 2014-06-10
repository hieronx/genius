
ActiveRecord.Callbacks =

  on: (event, callback) ->
    @callbacks = @callbacks or {}
    @callbacks[event] = @callbacks[event] or []
    @callbacks[event].push callback
    this

  trigger: (name, data) ->
    @callbacks = @callbacks or {}
    callbacks = @callbacks[name]
    if callbacks
      i = 0

      while i < callbacks.length
        callbacks[i].apply this, data or []
        i++
    this

  off: (event, callback) ->
    @callbacks = @callbacks or {}
    if callback
      callbacks = @callbacks[event] or []
      i = 0

      while i < callbacks.length
        @callbacks[event].splice i, 1  if callbacks[i] is callback
        i++
    else
      delete @callbacks[event]
    this
