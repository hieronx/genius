app = angular.module("geniusApp")

app.factory "connectionService", ($compile, $rootScope) ->

  # When a new connection is made by hand, ensure the list of genes is restricted
  initializeGenesConnection = (new_conn, pos_from_id, pos_to_id, duplicate, moved, value) ->
    Position.find pos_to_id, (position) ->
      $overlay = $(jsPlumb.getConnections({ source: pos_from_id, target: pos_to_id })[0].getOverlays()[0].getElement())
      $overlay.find("option[value='blank']").remove()
      
      Connection.find new_conn.id, (conn) ->
        _.each $rootScope.usedGenes, (gene) =>
          if gene isnt conn.attributes.selected
            $overlay.find("option[value='#{gene}']").prop('disabled', true).hide()

        $genes = _.difference $rootScope.genes, $rootScope.usedGenes

        if moved || duplicate
          conn.update { selected: value }, (conn) ->
            $overlay.val(conn.selected)
        else
          conn.update { selected: $genes[0] }, (conn) ->
            $rootScope.usedGenes.push $genes[0]
            $overlay.val(conn.selected)

    Brick.find $rootScope.currentBrick.attributes.id, (brick) ->
      brick.connections.each (conn) ->
        _.each $rootScope.usedGenes, (gene) =>
          $overlay = $(jsPlumb.getConnections({ source: conn.attributes.position_from_id, target: conn.attributes.position_to_id })[0].getOverlays()[0].getElement())
          if gene isnt conn.attributes.selected
            $overlay.find("option[value='#{gene}']").prop('disabled', true).hide()

  # Possible to remove gene from used genes list
  removeFromUsedGenes = (value) ->
    $index = _.indexOf $rootScope.usedGenes, value

    if $index > -1
      $rootScope.usedGenes.splice $index, 1

    Brick.find $rootScope.currentBrick.attributes.id, (brick) ->
      brick.connections.each (conn) ->
        if $(jsPlumb.getConnections({ source: conn.attributes.position_from_id, target: conn.attributes.position_to_id }))[0]?
          overlay = $(jsPlumb.getConnections({ source: conn.attributes.position_from_id, target: conn.attributes.position_to_id }))[0].getOverlays()[0].getElement()
          $(overlay).find("option[value='#{value}']").prop('disabled', false).show()

  # When a new connection is loaded from the database, restrict the list of genes
  loadGenesConnection: (info, pos_from_id, pos_to_id) =>
    $overlay = $(info.connection.getOverlays()[0].getElement())
    $overlay.find("option[value='blank']").remove()

    Position.find pos_to_id, (position) ->
      thisConn = _.first _.filter(position.incoming_connections.collection, (conn) ->
        return pos_from_id is conn.attributes.position_from_id)

      $overlay.val(thisConn.attributes.selected)
      _.each $rootScope.usedGenes, (gene) =>
        if gene isnt thisConn.attributes.selected
          $overlay.find("option[value='#{gene}']").prop('disabled', true).hide()

  # When gene value of a connection is change, ensure its updated in the database
  updateGenesConnection: (info, pos_from_id, pos_to_id, value) ->
    Position.find pos_to_id, (position) ->
      thisConn = _.first _.filter(position.incoming_connections.collection, (conn) ->
        return pos_from_id is conn.attributes.position_from_id)

      $oldValue = thisConn.attributes.selected
      removeFromUsedGenes($oldValue)
  
      thisConn.set('selected', value)
      thisConn.save()

      $rootScope.usedGenes.push value

      $overlay = $(jsPlumb.getConnections(source: thisConn.attributes.position_from_id, target: thisConn.attributes.position_to_id)[0].getOverlays()[0].getElement())
      $overlay.val(value)

      $rootScope.currentBrick.connections.each (conn) ->
        if conn.attributes.id isnt thisConn.id
          $overlay = $(jsPlumb.getConnections(source: conn.attributes.position_from_id, target: conn.attributes.position_to_id)[0].getOverlays()[0].getElement())
          $overlay.find("option[value='#{$oldValue}']").prop('disabled', false).show()
          $overlay.find("option[value='#{value}']").prop('disabled', true).hide()

  # Ability to remove a connection from the database
  removeConnection: (info, pos_from_id, pos_to_id, end_index) ->
    Position.find pos_from_id, (position) ->
      $conn = _.first _.filter(position.outgoing_connections.collection, (conn) ->
        conn.attributes.position_to_id is pos_to_id and conn.attributes.endpoint_index is end_index)

      $value = $conn.attributes.selected
      removeFromUsedGenes($value)
      $conn.destroy()

  # Ability to remove all connections for a position from the database
  removeAllConnections: (pos_from_id) ->
    Position.find pos_from_id, (position) ->
      _.each position.outgoing_connections.collection, (conn) ->
        removeFromUsedGenes(conn.attributes.selected)
        conn.destroy()
      _.each position.incoming_connections.collection, (conn) ->
        removeFromUsedGenes(conn.attributes.selected)
        conn.destroy()

  # Ability to create a new connection and store it in the database
  createConnection: (info, pos_from_id, pos_to_id, end_index, duplicate, moved, value) ->
    Position.find pos_from_id, (position) ->
      position.outgoing_connections.create { position_to_id: pos_to_id, endpoint_index: end_index, brick_id: $rootScope.currentBrick.id() }, (conn) ->
        initializeGenesConnection(conn, pos_from_id, pos_to_id, duplicate, moved, value)
        
  # Add information to label to ensure correct dragging behaviour
  addLabelInformation: (info) ->
    $label = $('#label-' + info.connection.id)
    $label.data('sourceId', info.connection.source.id)
    $label.data('targetId', info.connection.target.id)
    $label.addClass(info.connection.source.id).addClass(info.connection.target.id)
