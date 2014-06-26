app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope, connectionService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)
    $isPresent = false

    # Ensure connections are updated in the database
    jsPlumb.bind "connection", (info, originalEvent) ->
      if originalEvent
        if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is info.targetEndpoint.id then $endpointIndex = 0 else $endpointIndex = 1

        unless $isPresent
          if jsPlumb.getConnections(source: info.sourceId).length > 1
            connectionService.createConnection(info, info.sourceId, info.targetId, $endpointIndex, true, false, $(jsPlumb.getConnections(source: info.sourceId)[0].getOverlays()[0].getElement()).val())
          else
            connectionService.createConnection(info, info.sourceId, info.targetId, $endpointIndex, false, false)
        connectionService.addLabelInformation(info)
      else
        connectionService.loadGenesConnection(info, info.sourceId, info.targetId)
      
      $(info.connection.getOverlays()[0].getElement()).on 'change', (event) ->
        val = this.value
        _. each jsPlumb.getConnections(source: info.sourceId), (conn) ->
          connectionService.updateGenesConnection(info, conn.sourceId, conn.targetId, val)
    
    # Any brick or gate cannot create a connection to itself
    jsPlumb.bind "beforeDrop", (info) ->

      # Set the variable that decides if a connection should be updated
      $elemConnections = jsPlumb.getConnections(target: info.targetId)
      $isPresent = _.contains($elemConnections, info.connection)

      # Ensure brick cannot connect to itself
      if $rootScope.usedGenes.length >= $rootScope.genes.length
        scope.flash 'danger', 'All genes are already used in this circuit!'
        return false
      else if info.sourceId is info.targetId
        scope.flash 'danger', 'It is not possible to create a connection from and to the same gate!'
        return false
      else if jsPlumb.getConnections(source: info.sourceId, target: info.targetId).length > 0 && jsPlumb.getConnections(source: info.sourceId, target: info.targetId)[0].endpoints[1].id isnt info.connection.endpoints[1].id
        scope.flash 'danger', 'It is not possible to make multiple connections from the same source to the same gate!'
        return false
      return true

    # Update the database when a connection is detatached
    jsPlumb.bind "connectionDetached", (info, originalEvent) ->
      if originalEvent
        if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is info.targetEndpoint.id then $endpointIndex = 0 else $endpointIndex = 1

        connectionService.removeConnection(info, info.sourceId, info.targetId, $endpointIndex, false)

    # Update the database when a connection is moved
    jsPlumb.bind "connectionMoved", (info, originalEvent) ->
      if jsPlumb.selectEndpoints(target: info.newTargetId).get(0).id is info.newTargetEndpoint.id then $endpointIndex = 0 else $endpointIndex = 1
      if jsPlumb.selectEndpoints(target: info.originalTargetId).get(0).id is info.originalTargetEndpoint.id then $oldEndpointIndex = 0 else $oldEndpointIndex = 1

      connectionService.removeConnection(info, info.newSourceId, info.originalTargetId, $oldEndpointIndex, true)
      connectionService.createConnection(info, info.newSourceId, info.newTargetId, $endpointIndex, false, true, $(info.connection.getOverlays()[0].getElement()).val())