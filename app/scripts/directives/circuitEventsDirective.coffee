app = angular.module("geniusApp")

app.directive "circuitEvents", ($compile, $rootScope) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitEvents)
    
    # Add information to label to ensure correct dragging behaviour
    jsPlumb.bind "connection", (info, originalEvent) ->
    	$label = $('#label-' + info.connection.id)
    	$label.data('sourceId', info.connection.source.id)
    	$label.data('targetId', info.connection.target.id)
    	$label.addClass(info.connection.source.id).addClass(info.connection.target.id)

    # Any brick or gate cannot create a connection to itself
   	jsPlumb.bind "beforeDrop", (info) ->
   		if info.sourceId is info.targetId
   			return false
   		return true 

    $('.brick-form').submit ->
      console.log("YAY!")



