app = angular.module("geniusApp")

app.directive "updateBrick", ($compile, $rootScope) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.updateBrick)
