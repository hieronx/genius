
class Brick extends ActiveRecord.Base
  @register()

  @hasMany 'Position'
  @hasMany 'Connection'
