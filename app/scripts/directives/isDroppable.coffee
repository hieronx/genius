"use strict"
angular.module("geniusApp").directive "isDroppable", (Brick, $compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      dropService.drop(scope, $(this), ui)
