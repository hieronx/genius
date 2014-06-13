app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope, Brick) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)

    # Add information to label to ensure correct dragging behaviour
    jsPlumb.bind "connection", (info, originalEvent) ->
      source = info.sourceId.slice 6
      target = info.targetId.slice 6

      $sourceEndId = info.connection.endpoints[0].id
      $targetEndId = info.connection.endpoints[1].id
      
      $index = 1
      if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is $targetEndId
        $index = 0
    
      sourceConnections = null
      targetConnections = null 
      sourceBrick = null
      targetBrick = null

      Brick.find(source).done (data) ->
        sourceBrick = data
      console.log sourceBrick
      unless sourceBrick.connections?
        sourceConnections = []
      else
        sourceConnections = sourceBrick.connections

      if connectionsIndexOf(sourceConnections, { target: target, sourceEndpoint: $sourceEndId, targetIndex: $index }) < 0
        sourceConnections.push { target: target, sourceEndpoint: $sourceEndId, targetIndex: $index }

      Brick.update(source, { connections: sourceConnections })
      
      Brick.find(target).done (data) ->
        targetBrick = data
      unless targetBrick.connections?
        targetConnections = []
      else
        targetConnections = targetBrick.connections

      if targetConnections.indexOf({ target: source, sourceEndpoint: $targetEndId }) < 0  
        targetConnections.push { target: source, sourceEndpoint: $targetEndId }
      
      Brick.update(target, { connections: targetConnections })

      $label = $('#label-' + info.connection.id)
      $label.data('sourceId', info.connection.source.id)
      $label.data('targetId', info.connection.target.id)
      $label.addClass(info.connection.source.id).addClass(info.connection.target.id)

    # Any brick or gate cannot create a connection to itself
    jsPlumb.bind "beforeDrop", (info) ->
      if info.sourceId is info.targetId
        return false
      return true

    # connectionIndexOf (connections, connection) ->
    #   i = 0
    #   for connectionsearch in connections
    #     if(connectionsearch.target == )
    #     i += 1
    #   return -1;