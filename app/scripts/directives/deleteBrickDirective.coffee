app = angular.module("geniusApp")

app.directive "deleteBrick", ($compile, $rootScope, Brick) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.deleteBrick)

    element.on "click", ->
      $rootScope.elPar = element.parent()
      $rootScope.brickId = scope.elPar.attr("id")
      $canid = scope.brickId

      jsPlumb.detachAllConnections(scope.elPar)
      jsPlumb.removeAllEndpoints(scope.elPar)

      $("#" + $canid).remove()

      index = $canid.slice 6
      Brick.destroy(index)