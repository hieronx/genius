
ActiveRecord.InstanceMethods =

  get: (name) ->
    @attributes[name]

  set: (name, value) ->
    @attributes[name] = value
    @trigger "change:" + name, [this]
    @

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

  reset: ->
    @errors.clear()
    @

  save: (callback) ->
    if @newRecord()
      hoodie.store.add(@type(), @attributes).done (@attributes) =>
        callback?.apply(@, arguments)
    else
      @update @attributes, callback
    @

  type: -> @constructor.name.toLowerCase()
