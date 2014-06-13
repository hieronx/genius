
class ActiveRecord.Base
  idAttribute: 'id'

  @extend: (scope, object = {}) ->
    (scope.initializers ||= []).push object.initialize if object.initialize?
    _.extend scope, _.omit(object, 'initialize')

  @include: (module) ->
    @extend @,   module.ClassMethods
    @extend @::, module.InstanceMethods

  @register: ->
    @name = /(\w+)\(/.exec(@toString())[1]
    window[@name] = @
    app = angular.module("geniusApp")
    app.factory @name, @

  @include ActiveRecord.Callbacks
  @include ActiveRecord.Attributes
  @include ActiveRecord.Collections
  @include ActiveRecord.Associations

  constructor: (args...) ->
    for initializer in @initializers || []
      initializer.apply @, args
    @initialize?.apply @, args
