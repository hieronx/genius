#global todomvc
"use strict"

###
The main controller for the app. The controller:
- retrieves and persists the model via the todoStorage service
- exposes the model to the template and provides event handlers
###
angular.module("geniusApp").controller "BricksCtrl", BricksCtrl = ($scope, Brick, Gate) ->

  $scope.gates = ->
    [
      { type: 'and' },
      { type: 'or' },
      { type: 'not' },
      { type: 'input' },
      { type: 'output' }
    ]

  $scope.private = ->
    []

  $scope.public = ->
    []
