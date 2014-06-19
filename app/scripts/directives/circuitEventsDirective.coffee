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
          connectionService.createConnection(info, info.sourceId, info.targetId, $endpointIndex)
        connectionService.addLabelInformation(info)
      else
        connectionService.loadGenesConnection(info, info.sourceId, info.targetId)

    # Any brick or gate cannot create a connection to itself
    jsPlumb.bind "beforeDrop", (info) ->

      # Set the variable that decides if a connection should be updated
      $elemConnections = jsPlumb.getConnections(target: info.targetId)
      $isPresent = _.contains($elemConnections, info.connection)

      # Ensure brick cannot connect to itself
      if info.sourceId is info.targetId
        scope.flash 'danger', 'Het is niet mogelijk om een connectie te maken van en naar dezelfde gate!'
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
      connectionService.createConnection(info, info.newSourceId, info.newTargetId, $endpointIndex)
