"use strict"

angular.module("geniusApp").directive "deleteBrick", (Block, $compile, $rootScope) ->
  restrict: "A"
  link: (scope, element, attributes) ->
  	options = scope.$eval(attributes.isDroppable) #allow options to be passed in
  	element.on 'click', ->
			$rootScope.par = element.parent()
			$rootScope.brickId = scope.par.attr('id')
			$('#' + scope.brickId).remove()
			jsPlumb.deleteEveryEndpoint()