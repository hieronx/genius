app = angular.module("geniusApp")

app.directive "isDraggable", ($rootScope, $timeout) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDraggable) #allow options to be passed in
    element.draggable options

    if scope.$last == true
      $timeout ->
        $rootScope.$emit 'ngRepeatFinished'