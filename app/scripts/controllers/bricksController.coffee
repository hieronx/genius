app = angular.module("geniusApp")

class BricksCtrl extends BaseCtrl

  @register app, 'BricksCtrl'
  @inject "$scope", "$rootScope", "Brick", "dropService", "simulationService"

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

    @$scope.run = =>
      @simulationService.run()

    @$scope.loadStoredBricks = =>      
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        @Brick.all().done (bricks) =>
          for brick in bricks
            ui =
              draggable: $('.bricks-container div.brick.brick-and')
              position:
                left: brick.left
                top: brick.top
            
            @dropService.drop(brick.id, @$rootScope, ui, false)

            unless typeof brick.connections is 'undefined'
              for connection in brick.connections
                jsPlumb.connect({ source: "brick-" + brick.id, target: "brick-" + connection }, @$rootScope.sourceEndPoint)