app = angular.module("geniusApp")

app.factory "connectionService", ($compile, $rootScope, Brick) ->
  # Check if a connection is present in an array
  # getConnectionByCondition = (connections, connection) ->
  #   if connection.type is 'forward'
  #     connections.filter (conn) ->
  #       return conn.target is connection.target and conn.sourceEndpoint is connection.sourceEndpoint and conn.targetIndex is connection.targetIndex
  #   else
  #     connections.filter (conn) ->
  #       return conn.target is connection.target and conn.sourceEndpoint is connection.sourceEndpoint

  # # Ability to remove a connection from a collection
  # removeConnectionByCondition = (connections, connection) ->
  #   if connection.type is 'forward'
  #     connections.filter (conn) ->
  #       return conn.target isnt connection.target or conn.targetIndex isnt connection.targetIndex
  #   else
  #     connections.filter (conn) ->
  #       return conn.target isnt connection.target

  # Ability to remove a connection from the database
  removeConnection: (info, pos_from_id, pos_to_id, end_index, con_type) ->
    console.log "REMOVE"
    Position.find pos_from_id, (position) ->
      console.log position.outgoing_connections.findWhere({ attributes: { position_to_id: pos_to_id}} )
    	# position.outgoing_connections.findWhere({ attributes: { position_from_id: pos_from_id, position_to_id: pos_to_id, endpoint_index: end_index }} ).destroy()

  # Ability to create a new connection and store it in the database
  createConnection: (info, pos_from_id, pos_to_id, end_index, con_type) ->
    console.log "CREATE"
    Position.find pos_from_id, (position) ->
      position.outgoing_connections.create({ position_to_id: pos_to_id, endpoint_index: end_index }, (data) ->
        console.log data)


  # # Update the connections for the source
  # updateSourceConnection: (info, source, target, $sourceEndId, $index) ->
  #   sourceConnections = sourceBrick = null

  #   Brick.find(source).done (data) ->
  #     sourceBrick = data

  #   if sourceBrick.connections? then sourceConnections = sourceBrick.connections else sourceConnections = []
  #   sourceConnections.push { target: target, sourceEndpoint: $sourceEndId, targetIndex: $index, type: 'forward' }
  #   Brick.update(source, { connections: sourceConnections })

  # # Update the connections for the target
  # updateTargetConnection: (info, source, target, $targetEndId) ->
  #   targetConnections = targetBrick = null

  #   Brick.find(target).done (data) ->
  #     targetBrick = data

  #   if targetBrick.connections? then targetConnections = targetBrick.connections else targetConnections = []
  #   targetConnections.push { target: source, sourceEndpoint: $targetEndId, type: 'backward' }
  #   Brick.update(target, { connections: targetConnections })

  # Add information to label to ensure correct dragging behaviour
  addLabelInformation: (info) ->
    $label = $('#label-' + info.connection.id)
    $label.data('sourceId', info.connection.source.id)
    $label.data('targetId', info.connection.target.id)
    $label.addClass(info.connection.source.id).addClass(info.connection.target.id)
