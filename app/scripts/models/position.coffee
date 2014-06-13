
class Position extends ActiveRecord.Base
  @boot()

  @belongsTo 'Brick'
  @hasMany 'Connection'
