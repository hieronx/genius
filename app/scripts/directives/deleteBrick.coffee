"use strict"

angular.module("geniusApp").directive "deleteBrick", ( $compile, $rootScope) ->
	restrict: "A"
	link: (scope, element, attributes) ->
  	options = scope.$eval(attributes.isDroppable) #allow options to be passed in
  	console.log "WORKS"
  	element.on 'click', ->
  		$rootScope.par = elemen.parent()
  		$rootScope.brickId = scope.par.attr ('id')
  		console.log($('#' + scope.brickId))
			# jsPlumb.reset
			console.log "POST"
			# $('#' + scope.brickId).remove()