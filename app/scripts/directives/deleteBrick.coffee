"use strict"

angular.module("geniusApp").directive "deleteBrick", ($compile) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.deleteBrick) #allow options to be passed in
    console.log "PRE"
    element.on 'click', ->
   #  	targetBoxId = $(this).parent().attr('id')
			# jsPlumb.detachAllConnections(targetBoxId)
			# jsPlumb.removeAllEndpoints(targetBoxId)
			# $('#' + targetBoxId).remove()
    	