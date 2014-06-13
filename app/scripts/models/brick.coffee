
class Brick extends ActiveRecord.Base
  @boot()

  @hasMany 'Position'
  @hasMany 'Connection'
