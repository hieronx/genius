app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope, connectionService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)
    $isPresent = false

    # Ensure connections are updated in the database
    jsPlumb.bind "connection", (info, originalEvent) ->

      if originalEvent
        $source = info.sourceId.slice 6
        $target = info.targetId.slice 6

        $sourceEndId = info.connection.endpoints[0].id
        $targetEndId = info.connection.endpoints[1].id

        if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is $targetEndId then $index = 0 else $index = 1

        unless $isPresent
          connectionService.updateSourceConnection(info, $source, $target, $sourceEndId, $index,)
          connectionService.updateTargetConnection(info, $source, $target, $targetEndId)
        connectionService.addLabelInformation(info)

    # Any brick or gate cannot create a connection to itself
    jsPlumb.bind "beforeDrop", (info) ->

      # Set the variable that decides if a connection should be updated
      $elemConnections = jsPlumb.getConnections(target: info.targetId)
      $isPresent = _.contains($elemConnections, info.connection)

      # Ensure brick cannot connect to itself
      if info.sourceId is info.targetId
        return false
      return true

    # Update the database when a connection is detatached
    jsPlumb.bind "connectionDetached", (info, originalEvent) ->
      $source = info.sourceId.slice 6
      $target = info.targetId.slice 6

      $sourceEndId = info.connection.endpoints[0].id
      $targetEndId = info.connection.endpoints[1].id

      if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is $targetEndId then $index = 0 else $index = 1

      connectionService.removeSourceConnection(info, $source, $target, $sourceEndId, $index)
      connectionService.removeTargetConnection(info, $source, $target, $targetEndId)

    # Update the database when a connection is moved
    jsPlumb.bind "connectionMoved", (info, originalEvent) ->
      $source = info.newSourceId.slice 6
      $oldTarget = info.originalTargetId.slice 6
      $newTarget = info.newTargetId.slice 6

      $sourceEndId = info.connection.endpoints[0].id
      $oldTargetEndId = info.originalTargetEndpoint.id
      $newTargetEndId = info.connection.endpoints[1].id

      if jsPlumb.selectEndpoints(target: info.newTargetId).get(0).id is $newTargetEndId then $index = 0 else $index = 1
      if jsPlumb.selectEndpoints(target: info.originalTargetId).get(0).id is $oldTargetEndId then $oldIndex = 0 else $oldIndex = 1

      connectionService.removeSourceConnection(info, $source, $oldTarget, $sourceEndId, $oldIndex)
      connectionService.removeTargetConnection(info, $source, $oldTarget, $oldTargetEndId)

      connectionService.updateSourceConnection(info, $source, $newTarget, $sourceEndId, $index)
      connectionService.updateTargetConnection(info, $source, $newTarget, $newTargetEndId)

