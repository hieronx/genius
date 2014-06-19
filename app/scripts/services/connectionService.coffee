app = angular.module("geniusApp")

app.factory "connectionService", ($compile, $rootScope, Brick) ->


  initializeGenesConnection =  (new_conn, pos_from_id, pos_to_id) ->
    Position.find pos_to_id, (position) ->
      otherConn = _.first _.filter(position.incoming_connections.collection, (conn) ->
          conn.attributes.id isnt new_conn.id)
      $overlay = $(jsPlumb.getConnections({ source: pos_from_id, target: pos_to_id })[0].getOverlays()[0].getElement())
      $overlay.find("option[value='blank']").remove()
      
      Connection.find new_conn.id, (conn) ->
        if otherConn?
          $genes = _.filter $rootScope.genes, (gen) ->
            return gen isnt otherConn.attributes.selected
          $overlay.find("option[value='#{otherConn.attributes.selected}']").hide()
        else
          $genes = $rootScope.genes

        
        conn.update { genes: $genes, selected: $genes[0] }, (conn) ->
          $overlay.val(conn.selected)

  # Ability to remove a connection from the database
  removeConnection: (info, pos_from_id, pos_to_id, end_index) ->
    Position.find pos_from_id, (position) ->
      _.filter(position.outgoing_connections.collection, (conn) ->
        conn.attributes.position_to_id is pos_to_id and conn.attributes.endpoint_index is end_index)[0].destroy()

  # Ability to remove all connections for a position from the database
  removeAllConnections: (pos_from_id) ->
    Position.find pos_from_id, (position) ->
      _.each position.outgoing_connections.collection, (conn) ->
        conn.destroy()
      _.each position.incoming_connections.collection, (conn) ->
        conn.destroy()

  # Ability to create a new connection and store it in the database
  createConnection: (info, pos_from_id, pos_to_id, end_index) ->
    Position.find pos_from_id, (position) ->
      position.outgoing_connections.create { position_to_id: pos_to_id, endpoint_index: end_index, brick_id: $rootScope.currentBrick.id() }, (conn) ->
        initializeGenesConnection(conn, pos_from_id, pos_to_id)

  # Add information to label to ensure correct dragging behaviour
  addLabelInformation: (info) ->
    $label = $('#label-' + info.connection.id)
    $label.data('sourceId', info.connection.source.id)
    $label.data('targetId', info.connection.target.id)
    $label.addClass(info.connection.source.id).addClass(info.connection.target.id)
