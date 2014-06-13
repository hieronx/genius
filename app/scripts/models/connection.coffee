
class Connection extends ActiveRecord.Base
  @boot()

  @belongsTo 'Brick'

  @belongsTo 'Position', { key: 'position_from', foreign_key: 'position_from_id' }
  @belongsTo 'Position', { key: 'position_to',   foreign_key: 'position_to_id'   }
