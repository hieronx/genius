"use strict"
angular.module("geniusApp").directive "isDroppable", (Block, $compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    index = 1
    element.droppable drop: (event, ui) ->
      dropService.drop(index, scope, $(this), event, ui)
      index++