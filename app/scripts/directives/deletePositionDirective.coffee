app = angular.module("geniusApp")

app.directive "deletePosition", ($compile, $rootScope, connectionService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.deletePosition)

    # Delete a position and all its elements, popovers and connections
    element.on "click", ->
      $elPar = element.parent()
      pid = $elPar.attr("id")

      connectionService.removeAllConnections(pid)
      Position.find pid, (position) =>
        position.destroy()

      $connLabel = $('.label.' + pid)
      $sourceId = $connLabel.data('sourceId')
      $targetId = $connLabel.data('targetId')

      $elPar.popover('destroy')
      $connLabel.popover('destroy')

      $('#' + $sourceId).removeClass('labelDisabled').draggable('enable')
      $('#' + $targetId).removeClass('labelDisabled').draggable('enable')
      
      jsPlumb.detachAllConnections($elPar)
      jsPlumb.removeAllEndpoints($elPar)
      $elPar.remove()
