
@ActiveRecord =
  Callbacks: {}

ActiveRecord.Callbacks.ClassMethods = ActiveRecord.Callbacks.InstanceMethods =

  on: (event, callback) ->
    ((@callbacks ||= {})[event] ||= []).push callback
    @

  trigger: (event, args...) ->
    _.each @callbacks?[event] || [], (callback) =>
      callback.apply @, args
    @

  off: (event, callback) ->
    if callback?
      @callbacks?[event] = _.without(@callbacks[event] || [], callback)
    else
      delete @callbacks?[event]
    @
