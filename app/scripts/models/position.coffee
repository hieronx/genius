
class Position extends ActiveRecord.Base
  @boot()

  @belongsTo 'Brick'
  @hasMany 'Connection', { key: 'outgoing_connections', foreign_key: 'position_from_id' }
  @hasMany 'Connection', { key: 'incoming_connections', foreign_key: 'position_to_id' }
