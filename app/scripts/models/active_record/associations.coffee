
ActiveRecord.Associations =

  ClassMethods:

    belongsTo: (className, options = {}) ->
      @::associations ||= {}
      @::associations.belongsTo ||= []
      @::associations.belongsTo.push [className, options]

    hasMany: (className, options = {}) ->
      @::associations ||= {}
      @::associations.hasMany ||= []
      @::associations.hasMany.push [className, options]

  InstanceMethods:

    initialize: ->
      _.each @associations, (associations, method) =>
        _.each associations, (association) =>
          @[method].apply @, association

    belongsTo: (className, options = {}) ->
      # set options with defaults
      model = window[className]
      options = _.extend {
        key: @model.type()
        foreign_key: "#{@model.type()}_id"
        foreign_object: @model.type()
      }, options

      # set initial object
      @[options.key] = null
      if @has(options.foreign_object)
        @[options.key] = new model @get(options.foreign_object)
      else if @has(options.foreign_key)
        @[options.key] = model.find @get(options.foreign_key)

      # update object on change
      @on "change:#{options.foreign_object}", =>
        if @[options.key]?
          _.each @get(options.foreign_object), (value, key) =>
            @[options.key].set key, value
        else
          @[options.key] = new model @get(options.foreign_object)
      @on "change:#{options.foreign_key}", =>
        @[options.key] = model.find @get(options.foreign_key)

    hasMany: (className, options = {}) ->
      # set options with defaults
      model = window[className]
      options = _.extend {
        key: "#{model.type()}s"
        foreign_key: "#{@type()}_id"
        foreign_object: "#{model.type()}s"
      }, options

      # set initial objects
      @[options.key] = model.clone()
      if @has(options.foreign_object)
        _.each @get(options.foreign_object), (object) =>
          if object.length == 1 and object.id?
            instance = model.find(object.id)
          else
            instance = new model(object)
          @[options.key].add instance
      model.each (instance) =>
        if instance.has(options.foreign_key) and instance.get(options.foreign_key) == @id()
          @[options.key].add instance

      # update objects on change
      @on "change:#{options.foreign_object}", =>
        _.each @get(options.foreign_object), (object) =>
          if object.length == 1 and object.id?
            instance = model.find(object.id)
          else
            instance = new model(object)
          @[options.key].add instance
      model.on 'add', (instance) =>
        if instance.has(options.foreign_key) and instance.get(options.foreign_key) == @id()
          @[options.key].add instance
      model.on 'remove', (instance) =>
        if instance.has(options.foreign_key) and instance.get(options.foreign_key) == @id()
          @[options.key].remove instance
