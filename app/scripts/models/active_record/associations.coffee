
ActiveRecord.Associations =

  ClassMethods:

    belongsTo: (className, options = {}) ->
      ((@::associations ||= {}).belongsTo ||= []).push _.extend({
        className: className
        key: "#{className.toLowerCase()}"
        foreign_key: "#{className.toLowerCase()}_id"
        foreign_object: "#{className.toLowerCase()}"
      }, options)

    hasMany: (className, options = {}) ->
      ((@::associations ||= {}).hasMany ||= []).push _.extend({
        className: className
        key: "#{className.toLowerCase()}s"
        foreign_key: "#{@type()}_id"
        foreign_object: "#{className.toLowerCase()}s"
      }, options)

  InstanceMethods:

    initialize: ->
      _.each @associations, (associations, method) =>
        _.each associations, (association) =>
          @["_#{method}"].call @, association

    _belongsTo: (options = {}) ->
      model = window[options.className]

      # set initial object
      @[options.key] = null
      if @has(options.foreign_object)
        @[options.key] = new model @get(options.foreign_object)
      else if @has(options.foreign_key)
        model.find @get(options.foreign_key), (instance) =>
          @[options.key] = instance if instance?

      # update object on change
      @on "change:#{options.foreign_object}", =>
        if @[options.key]?
          _.each @get(options.foreign_object), (value, key) =>
            @[options.key].set key, value
        else
          @[options.key] = new model @get(options.foreign_object)
      @on "change:#{options.foreign_key}", =>
        model.find @get(options.foreign_key), (instance) =>
          @[options.key] = instance if instance?

    _hasMany: (options = {}) ->
      model = window[options.className]

      # prepare has may collection
      @[options.key] =
        collection: {}
        all: -> @collection
        find: (id) -> @detect (m) -> m.id() == id
        new: (attributes = {}) =>
          attributes[options.foreign_key] ||= @id()
          new model(attributes)
      _.each ActiveRecord.Callbacks.ClassMethods, (method, name) =>
        @[options.key][name] = method
      _.each _.omit(ActiveRecord.Collections.ClassMethods, 'all', 'find', 'new', 'type'), (method, name) =>
        @[options.key][name] = method

      # set initial objects
      if @has(options.foreign_object) and _.isArray(@get(options.foreign_object))
        _.each @get(options.foreign_object), (attributes) =>
          @[options.key].add @_attributesToObject(attributes, model)
      model.each (instance) =>
        if instance.has(options.foreign_key) and instance.get(options.foreign_key) == @id()
          @[options.key].add instance

      # update objects on change
      @on "change:#{options.foreign_object}", =>
        _.each @get(options.foreign_object), (attributes) =>
          @[options.key].add @_attributesToObject(attributes, model)
      model.on 'add', (instance) =>
        if instance.has(options.foreign_key) and instance.get(options.foreign_key) == @id()
          @[options.key].add instance
      model.on 'remove', (instance) =>
        if instance.has(options.foreign_key) and instance.get(options.foreign_key) == @id()
          @[options.key].remove instance

    _attributesToObject: (attributes, model) ->
      if attributes.length == 1 and attributes.id?
        model.find(attributes.id)
      else
        new model(attributes)
