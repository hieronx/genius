class @Base
  defer: hoodie?.defer?()

  @register: (app, name) ->
    name ?= @name || @toString().match(/function\s*(.*?)\(/)?[1]
    app.factory name, @

  all: ->
    hoodie.store.findAll(@type).done (items) =>
      @defer.resolve items
    @defer.promise()

  find: (index) ->
    hoodie.store.find(@type, index).done (item) =>
      @defer.resolve item
    @defer.promise()

  where: (properties) ->
    hoodie.store.findAll(@type).done (items) =>
      @defer.resolve _.where(items, properties)
    @defer.promise()

  add: (attributes) ->
    hoodie.store.add(@type, attributes).done (item) =>
      @defer.resolve item
    @defer.promise()

  destroy: (index) ->
    hoodie.store.remove(@type, index).done (item) =>
      @defer.resolve item
    @defer.promise()

  size: ->
    hoodie.store.findAll(@type).done (items) =>
      @defer.resolve items.length
    @defer.promise()
