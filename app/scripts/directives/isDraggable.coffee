"use strict"

angular.module("geniusApp").directive "isDraggable", ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDraggable) #allow options to be passed in
    element.draggable options
