@ActiveRecord = {}

class ActiveRecord.Base
  idAttribute: 'id'

  @register: ->
    @name = /(\w+)\(/.exec(@toString())[1]

    _.extend @, ActiveRecord.Callbacks
    _.extend @, ActiveRecord.ClassMethods
    _.extend @::, ActiveRecord.Callbacks
    _.extend @::, ActiveRecord.InstanceMethods

    window[@name] = @

    app = angular.module("geniusApp")
    app.factory @name, @

  constructor: (@attributes) ->
    @attributes ||= []
