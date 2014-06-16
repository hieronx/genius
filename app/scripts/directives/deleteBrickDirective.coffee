app = angular.module("geniusApp")

app.directive "deleteBrick", ($compile, $rootScope) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.deleteBrick)

    # Delete a brick and all its elements, popovers and connections
    element.on "click", ->
      $elPar = element.parent()
      $brickId = $elPar.attr("id")
      Brick.find $brickId, (brick) =>
        brick.destroy()

      $connLabel = $('.label.' + $brickId)
      $sourceId = $connLabel.data('sourceId')
      $targetId = $connLabel.data('targetId')

      $elPar.popover('destroy')
      $connLabel.popover('destroy')

      $('#' + $sourceId).removeClass('labelDisabled').draggable('enable')
      $('#' + $targetId).removeClass('labelDisabled').draggable('enable')

      jsPlumb.detachAllConnections($elPar)
      jsPlumb.removeAllEndpoints($elPar)
      $elPar.remove()
