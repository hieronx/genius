app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)

    # Add information to label to ensure correct dragging behaviour
    jsPlumb.bind "connection", (info, originalEvent) ->
      sourceId = info.sourceId.slice 6
      targetId = info.targetId.slice 6

      $sourceEndId = info.connection.endpoints[0].id
      $targetEndId = info.connection.endpoints[1].id

      $index = 1
      if jsPlumb.selectEndpoints(target: info.targetId).get(0).id is $targetEndId
        $index = 0

      Brick.find sourceId, (source) =>
        source.set 'connections', [{ target: target.id(), sourceEndpoint: $sourceEndId, targetIndex: $index }]
        source.save()

      $label = $('#label-' + info.connection.id)
      $label.data('sourceId', info.connection.source.id)
      $label.data('targetId', info.connection.target.id)
      $label.addClass(info.connection.source.id).addClass(info.connection.target.id)

    # Any brick or gate cannot create a connection to itself
    jsPlumb.bind "beforeDrop", (info) ->
      if info.sourceId is info.targetId
        return false
      return true
