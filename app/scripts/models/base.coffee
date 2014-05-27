class @Base
  defer: hoodie?.defer?()
  database: hoodie?.store

  @register: (app, name) ->
    name ?= @name || @toString().match(/function\s*(.*?)\(/)?[1]
    app.service name, @

  all: ->
    @database.findAll(@type).done (items) =>
      @defer.resolve items
    @defer.promise()

  find: (index) ->
    @database.find(@type, index).done (item) =>
      @defer.resolve item
    @defer.promise()

  where: (properties) ->
    @database.findAll(@type).done (items) =>
      @defer.resolve _.where(items, properties)
    @defer.promise()

  add: (attributes) ->
    @database.add(@type, attributes).done (item) =>
      @defer.resolve item
    @defer.promise()

  update: (index, attributes) ->
    @database.update(@type, index, attributes).done (item) =>
      @defer.resolve item
    @defer.promise()

  destroy: (index) ->
    @database.remove(@type, index).done (item) =>
      @defer.resolve item
    @defer.promise()

  size: ->
    @database.findAll(@type).done (items) =>
      @defer.resolve items.length
    @defer.promise()
