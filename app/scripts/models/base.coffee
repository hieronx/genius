class @Base extends Model
  database: hoodie?.store

  @register: (app, name) ->
    @name ?= @name || @toString().match(/function\s*(.*?)\(/)?[1]
    app.service @name, @

  type: -> @name.toLowerCase()
