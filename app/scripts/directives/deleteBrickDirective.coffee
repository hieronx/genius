app = angular.module("geniusApp")

app.directive "deleteBrick", ($compile, $rootScope) ->
	restrict: "A"
	link: (scope, element, attributes) ->
		options = scope.$eval(attributes.deleteBrick)

		element.on "click", ->
			$rootScope.elPar = element.parent()
			$rootScope.brickId = scope.elPar.attr("id")
			jsPlumb.detachAllConnections(scope.elPar)
			jsPlumb.removeAllEndpoints(scope.elPar)
			$("#" + scope.brickId).remove()
