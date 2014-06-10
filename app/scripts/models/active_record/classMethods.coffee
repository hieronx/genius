
ActiveRecord.ClassMethods =
  collection: []

  add: (model) ->
    id = model.id()
    unless _.contains(@collection, model) or (id and @find((m)->m.id() == id))
      @collection.push model
      @trigger "add", [model]
    @

  fetch: (callback) ->
    hoodie.store.findAll(@type()).done (models) =>
      @add new @(model) for model in models
      callback.call @, @collection if callback
    @

  remove: (model) ->
    i = 0
    for m in @collection
      if m is model
        index = i
        break
      i++
    if index?
      @collection.splice index, 1
      @trigger "remove", [model]
      true
    else
      false

  type: -> @name.toLowerCase()

_.each _.without(_.keys(_), 'VERSION'), (method) ->
  ActiveRecord.ClassMethods[method] = ->
    args = [].slice.call(arguments);
    args.unshift(@collection);
    _[method].apply(_, args);
