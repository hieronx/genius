app = angular.module("geniusApp")

class BricksCtrl extends BaseCtrl

  @register app, 'BricksCtrl'
  @inject "$scope", "$rootScope", "Brick", "dropService"

  initialize: ->
    @$scope.gates =
      [
        { type: 'AND' },
        { type: 'OR' },
        { type: 'NOT' },
        { type: 'INPUT' },
        { type: 'OUTPUT' }
      ]

    @$scope.private = []

    @$scope.public = []

  loadStoredBricks = ->
    Brick.all().done (bricks) ->
      for brick in bricks
        ui =
          draggable: $('.bricks-container div.brick.gate-and.ng-scope.ui-draggable')
          position:
            left: brick.left
            top: brick.top
        dropService.drop($rootScope, ui, false)
