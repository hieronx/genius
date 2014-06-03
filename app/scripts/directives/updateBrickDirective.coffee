app = angular.module("geniusApp")

app.directive "updateBrick", ($compile, $rootScope, Brick) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.updateBrick)