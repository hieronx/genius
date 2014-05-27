class @Base
  database: hoodie?.store

  @register: (app, name) ->
    name ?= @name || @toString().match(/function\s*(.*?)\(/)?[1]
    app.service name, @

  all: ->
    @database.findAll(@type)

  find: (index) ->
    @database.find(@type, index)

  where: (properties) ->
    @database.findAll(@type)

  add: (attributes) ->
    @database.add(@type, attributes)

  update: (index, attributes) ->
    @database.update(@type, index, attributes)

  destroy: (index) ->
    @database.remove(@type, index)

  size: ->
    @database.findAll(@type)