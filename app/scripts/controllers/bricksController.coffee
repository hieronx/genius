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

    @$scope.loadStoredBricks = =>
      console.log "1"
      
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        console.log "2"

        @Brick.all().done (bricks) =>
          for brick in bricks
            ui =
              draggable: $('.bricks-container div.brick.brick-and')
              position:
                left: brick.left
                top: brick.top

            console.log "3"
            console.log ui.draggable
            
            @dropService.drop(@$rootScope, ui, false)