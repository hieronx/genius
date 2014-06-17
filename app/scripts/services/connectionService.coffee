app = angular.module("geniusApp")

app.factory "connectionService", ($compile, $rootScope, Brick) ->

  # Ability to remove a connection from the database
  removeConnection: (info, pos_from_id, pos_to_id, end_index) ->
    Position.find pos_from_id, (position) ->
      _.filter(position.outgoing_connections.collection, (conn) ->
        conn.attributes.position_to_id is pos_to_id and conn.attributes.endpoint_index is end_index)[0].destroy()

  # Ability to create a new connection and store it in the database
  createConnection: (info, pos_from_id, pos_to_id, end_index) ->
    Position.find pos_from_id, (position) ->
      position.outgoing_connections.create({ position_to_id: pos_to_id, endpoint_index: end_index, brick_id: $rootScope.currentBrick.id() })

  # Add information to label to ensure correct dragging behaviour
  addLabelInformation: (info) ->
    $label = $('#label-' + info.connection.id)
    $label.data('sourceId', info.connection.source.id)
    $label.data('targetId', info.connection.target.id)
    $label.addClass(info.connection.source.id).addClass(info.connection.target.id)
