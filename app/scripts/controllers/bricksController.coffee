app = angular.module("geniusApp")

class BricksCtrl extends BaseCtrl

  @register app, 'BricksCtrl'
  @inject "$scope", "$rootScope", "Brick", "dropService", "_"

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
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        @Brick.all().done (bricks) =>
          for brick in bricks
            ui =
              draggable: $('.bricks-container div.brick.brick-and')
              position:
                left: brick.left
                top: brick.top

            @dropService.drop(brick.id, @$rootScope, ui, false)

    @$scope.collapse =
      gates: false
      private: false
      public: false

    @$scope.filter = (type) =>
      @$scope.collapse[type] = not @$scope.collapse[type]

    @$scope.new = =>
      # new brick

    @$scope.copy = =>
      # copy brick

    @$scope.run = =>
      # run brick

    @$scope.export = =>
      # export brick
