#global todomvc
"use strict"

###
The main controller for the app. The controller:
- retrieves and persists the model via the todoStorage service
- exposes the model to the template and provides event handlers
###
angular.module("geniusApp").controller "MainCtrl", MainCtrl = ($scope, Brick, dropService) ->

  Brick.all().done (bricks) ->
    for brick in bricks
      ui =
        draggable: $('div.brick.gate-and.ng-scope.ui-draggable')
        position:
          left: brick.left
          top: brick.top
      dropService.drop(0, $scope, $('#workspace'), ui)