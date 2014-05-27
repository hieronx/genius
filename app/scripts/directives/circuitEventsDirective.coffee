app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)
    
    jsPlumb.bind "connection", (info, originalEvent) ->
    	$label = $('#label-' + info.connection.id)
    	$label.data('sourceId', info.connection.source.id)
    	$label.data('targetId', info.connection.target.id)



