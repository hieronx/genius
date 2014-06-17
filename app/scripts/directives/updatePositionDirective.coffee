app = angular.module("geniusApp")

app.directive "updatePosition", ($compile, $rootScope) ->
  restrict: 'A'
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.updatePosition)
