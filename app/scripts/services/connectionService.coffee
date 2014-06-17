app = angular.module("geniusApp")

app.factory "connectionService", ($compile, $rootScope, Brick) ->

  # Ability to remove a connection from the database
  removeConnection: (info, pos_from_id, pos_to_id, end_index, con_type) ->
    console.log "REMOVE"
    Position.find pos_from_id, (position) ->
      console.log position.outgoing_connections.findWhere( attributes: { position_to_id: pos_to_id} )
    	# position.outgoing_connections.findWhere({ attributes: { position_from_id: pos_from_id, position_to_id: pos_to_id, endpoint_index: end_index }} ).destroy()

  # Ability to create a new connection and store it in the database
  createConnection: (info, pos_from_id, pos_to_id, end_index, con_type) ->
    console.log "CREATE"
    Position.find pos_from_id, (position) ->
      position.outgoing_connections.create({ position_to_id: pos_to_id, endpoint_index: end_index, brick_id: $rootScope.currentBrick.id() }, (data) ->
        console.log data)

  # Add information to label to ensure correct dragging behaviour
  addLabelInformation: (info) ->
    $label = $('#label-' + info.connection.id)
    $label.data('sourceId', info.connection.source.id)
    $label.data('targetId', info.connection.target.id)
    $label.addClass(info.connection.source.id).addClass(info.connection.target.id)
