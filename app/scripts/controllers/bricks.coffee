#global todomvc
"use strict"

###
The main controller for the app. The controller:
- retrieves and persists the model via the todoStorage service
- exposes the model to the template and provides event handlers
###
angular.module("geniusApp").controller "BricksCtrl", BricksCtrl = ($scope, Brick, dropService) ->

  $scope.gates =
    [
      { type: 'AND' },
      { type: 'OR' },
      { type: 'NOT' },
      { type: 'INPUT' },
      { type: 'OUTPUT' }
    ]

  $scope.private =
    []

  $scope.public =
    []

  $scope.loadStoredBricks = ->
    Brick.all().done (bricks) ->
      for brick in bricks
        ui =
          draggable: $('div.brick.gate-and.ng-scope.ui-draggable')
          position:
            left: brick.left
            top: brick.top
        dropService.drop($scope, ui, false)
