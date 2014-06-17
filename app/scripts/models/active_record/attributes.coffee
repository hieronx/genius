
ActiveRecord.Attributes =

  InstanceMethods:

    initialize: (attributes) ->
      @attributes = {}
      _.each attributes, (value, key) =>
        @set key, value
      @isSaving = false

    get: (key) ->
      @attributes[key]

    set: (key, value) ->
      @attributes[key] = value
      @trigger "change:#{key}", @
      @

    has: (key) ->
      @get(key)?

    destroy: (callback) ->
      hoodie.store.remove(@type(), @id()).done =>
        @constructor.remove @
        callback?.apply(@, arguments)

    update: (attributes, callback) ->
      _.each attributes, (value, key) =>
        @set key, value
      @save(callback)

    id: ->
      @attributes[@idAttribute]

    newRecord: ->
      not @id()?

    save: (callback) ->
      @isSaving = true
      if @newRecord()
        hoodie.store.add(@type(), @attributes).done (@attributes) =>
          @isSaving = false
          @constructor.add @
          callback?.apply(@, arguments)
      else
        hoodie.store.update(@type(), @id(), @attributes).done (@attributes) =>
          @isSaving = false
          callback?.apply(@, arguments)
      @

    type: -> @constructor.name.toLowerCase()

_.each ['keys', 'values', 'pairs', 'invert', 'pick', 'omit'], (method) ->
  ActiveRecord.Attributes.InstanceMethods[method] = ->
    args = [].slice.call(arguments);
    args.unshift(@attributes);
    _[method].apply(_, args);
