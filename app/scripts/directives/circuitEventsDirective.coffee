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
            console.log "OVERLAYY", $(jsPlumb.getConnections(source: info.sourceId)[0].getOverlays()[0].getElement()).val()
            connectionService.createConnection(info, info.sourceId, info.targetId, $endpointIndex, true, false, $(jsPlumb.getConnections(source: info.sourceId)[0].getOverlays()[0].getElement()).val())
          else
            connectionService.createConnection(info, info.sourceId, info.targetId, $endpointIndex, false, false)
        connectionService.addLabelInformation(info)
      else
        connectionService.loadGenesConnection(info, info.sourceId, info.targetId)

      # if jsPlumb.getConnections(source: info.sourceId).length > 1
      #   connectionService.syncGenesConnection(info, info.sourceId, info.targetId)
      
      $(info.connection.getOverlays()[0].getElement()).on 'change', (event) ->
        connectionService.updateGenesConnection(info, info.sourceId, info.targetId, this.value)
        
        # if jsPlumb.getConnections(source: info.sourceId).length > 1
        #   connectionService.syncOtherGenesConnection(info, info.sourceId, info.targetId)
        # else

    # Any brick or gate cannot create a connection to itself
    jsPlumb.bind "beforeDrop", (info) ->

      # Set the variable that decides if a connection should be updated
      $elemConnections = jsPlumb.getConnections(target: info.targetId)
      $isPresent = _.contains($elemConnections, info.connection)

      # Ensure brick cannot connect to itself
      if info.sourceId is info.targetId
        scope.flash 'danger', 'It is not possible to create a connection from and to the same gate!'
        return false
      return true

    # Update the database when a connection is detatached
    jsPlumb.bind "connectionDetached", (info, originalEvent) ->
      if originalEvent
        if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is info.targetEndpoint.id then $endpointIndex = 0 else $endpointIndex = 1

        connectionService.removeConnection(info, info.sourceId, info.targetId, $endpointIndex)

    # Update the database when a connection is moved
    jsPlumb.bind "connectionMoved", (info, originalEvent) ->
      if jsPlumb.selectEndpoints(target: info.newTargetId).get(0).id is info.newTargetEndpoint.id then $endpointIndex = 0 else $endpointIndex = 1
      if jsPlumb.selectEndpoints(target: info.originalTargetId).get(0).id is info.originalTargetEndpoint.id then $oldEndpointIndex = 0 else $oldEndpointIndex = 1

      connectionService.removeConnection(info, info.newSourceId, info.originalTargetId, $oldEndpointIndex)
      connectionService.createConnection(info, info.newSourceId, info.newTargetId, $endpointIndex, false, true, $(info.connection.getOverlays()[0].getElement()).val())

      # connectionService.updateGenesConnection(info, info.newSourceId, info.newTargetId, )