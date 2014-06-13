
ActiveRecord.Collections =

  ClassMethods:
    initialize: ->
      @collection = {}

    add: (model) ->
      unless not model? or model.newRecord() or @find(model.id())?
        @collection[model.id()] = model
        @trigger "add", model
      @

    all: (callback) ->
      hoodie.store.findAll(@type()).done (models) =>
        @add new @(model) for model in models
        callback?.call @, @collection
      @

    remove: (model) ->
      if @collection[model.id()]?
        delete @collection[model.id()]
        @trigger "remove", model
        true
      else
        false

    find: (id, callback) ->
      model = null
      hoodie.store.find(@type(), id).done (m) =>
        @add model = @(m)
        callback.call @, model if callback?
      model

    new: (attributes) ->
      new @(attributes)

    create: (attributes, callback) ->
      @new(attributes).save(callback)

    type: -> @name.toLowerCase()

_.each _.without(_.keys(_), 'VERSION', 'find', 'all', 'extend', 'include'), (method) ->
  ActiveRecord.Collections.ClassMethods[method] = ->
    args = [].slice.call(arguments);
    args.unshift(_.values(@collection));
    _[method].apply(_, args);
