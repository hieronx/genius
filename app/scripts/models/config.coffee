
class Config extends ActiveRecord.Base

  @boot: ->
    super
    @all()

  @boot()

  @get: (key) ->
    _.first(@filter((c) -> c.get('key') == key))?.get('value')

  @has: (key) ->
    _.first(@filter((c) -> c.get('key') == key))?

  @set: (key, value) ->
    config = _.first(@filter((c) -> c.get('key') == key))
    if config?
      config.update { value: value }
    else
      @create { key: key, value: value }
