app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope, Brick) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)

    # Add information to label to ensure correct dragging behaviour
    jsPlumb.bind "connection", (info, originalEvent) ->
      source = info.sourceId.slice 6
      target = info.targetId.slice 6
      
      # console.log info.connection

      $sourceEndId = info.connection.endpoints[0].id
      $targetEndId = info.connection.endpoints[1].id
      
      $index = 1
      if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is $targetEndId
        $index = 0
  
      Brick.update(source, { connections: [{ target: target, sourceEndpoint: $sourceEndId, targetIndex: $index }] })

      $label = $('#label-' + info.connection.id)
      $label.data('sourceId', info.connection.source.id)
      $label.data('targetId', info.connection.target.id)
      $label.addClass(info.connection.source.id).addClass(info.connection.target.id)

    # Any brick or gate cannot create a connection to itself
    jsPlumb.bind "beforeDrop", (info) ->
      if info.sourceId is info.targetId
        return false
      return true
