
ActiveRecord.Attributes =

  InstanceMethods:

    initialize: (attributes) ->
      @attributes = []
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
      hoodie.store.update(@type(), @id(), attributes).done =>
        callback?.apply(@, arguments)

    id: ->
      @attributes[@idAttribute]

    newRecord: ->
      not @id()?

    save: (callback) ->
      @isSaving = true
      if @newRecord()
        hoodie.store.add(@type(), @attributes).done (@attributes) =>
          @isSaving = false
          callback?.apply(@, arguments)
      else
        @update @attributes, =>
          @isSaving = false
          callback?.apply(@, arguments)
      @

    type: -> @constructor.name.toLowerCase()
