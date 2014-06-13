
class Position extends ActiveRecord.Base
  @register()

  @belongsTo 'Brick'
  @hasMany 'Connection'
