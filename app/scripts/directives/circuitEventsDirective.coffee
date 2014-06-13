app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope, Brick) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)

    # Ensure connections are updated in the database
    jsPlumb.bind "connection", (info, originalEvent) ->
      # source = info.sourceId.slice 6
      # target = info.targetId.slice 6

      # Brick.find(source).done (data) ->
      #   console.log data

      # Brick.find(target).done (data) ->
      #   console.log data

      if originalEvent
        $source = info.sourceId.slice 6
        $target = info.targetId.slice 6

        $sourceEndId = info.connection.endpoints[0].id
        $targetEndId = info.connection.endpoints[1].id

        if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is $targetEndId then $index = 0 else $index = 1

        updateSourceConnection(info, $source, $target, $sourceEndId, $index,)
        updateTargetConnection(info, $source, $target, $targetEndId)
        addLabelInformation(info)

    # Any brick or gate cannot create a connection to itselfn
    jsPlumb.bind "beforeDrop", (info) ->
      if info.sourceId is info.targetId
        return false
      return true

    # Update the connections for the source
    updateSourceConnection = (info, source, target, $sourceEndId, $index) ->
      sourceConnections = sourceBrick = null

      Brick.find(source).done (data) ->
        sourceBrick = data

      if sourceBrick.connections? then sourceConnections = sourceBrick.connections else sourceConnections = []
      sourceConnections.push { target: target, sourceEndpoint: $sourceEndId, targetIndex: $index, type: 'forward' }
      Brick.update(source, { connections: sourceConnections })

    # Update the connections for the target
    updateTargetConnection = (info, source, target, $targetEndId) ->
      targetConnections = targetBrick = null

      Brick.find(target).done (data) ->
        targetBrick = data

      if targetBrick.connections? then targetConnections = targetBrick.connections else targetConnections = []
      targetConnections.push { target: source, sourceEndpoint: $targetEndId, type: 'backward' }
      Brick.update(target, { connections: targetConnections })

    # Add information to label to ensure correct dragging behaviour
    addLabelInformation = (info) ->
      $label = $('#label-' + info.connection.id)
      $label.data('sourceId', info.connection.source.id)
      $label.data('targetId', info.connection.target.id)
      $label.addClass(info.connection.source.id).addClass(info.connection.target.id)

    # Check if a connection is present in an array
    connectionContained = (connections, connection) ->
      if connection.type is 'forward'
        connections.filter (conn) ->
          return conn.target is connection.target and conn.sourceEndpoint is connection.sourceEndpoint and conn.targetIndex is connection.targetIndex
      else
        connections.filter (conn) ->
          return conn.target is connection.target and conn.sourceEndpoint is connection.sourceEndpoint



