
class Config extends ActiveRecord.Base

  @boot: ->
    super
    @all()

  @boot()

  @get: (key) ->
    @findWhere({ key: key }).get('value')

  @set: (key, value) ->
    config = @findWhere({ key: key })
    if config?
      config.update { value: value }
    else
      config.create { key: key, value: value }
