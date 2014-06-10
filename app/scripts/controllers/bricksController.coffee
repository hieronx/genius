app = angular.module("geniusApp")

class BricksCtrl extends BaseCtrl

  @register app, 'BricksCtrl'
  @inject "$scope", "$rootScope", "Brick", "dropService", "importCSV", "_"

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
      @importCSV.storeBiobricks()
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        @Brick.all().done (bricks) =>
          for brick in bricks
            ui =
              draggable: $('.brick-container div.brick.' + brick.brick_type)
              position:
                left: brick.left
                top: brick.top

            @dropService.drop(brick.id, @$rootScope, ui, false)


          for brick in bricks
            unless typeof brick.connections is 'undefined'
              for connection in brick.connections
                $sourceId = 'brick-' + brick.id
                $source = jsPlumb.selectEndpoints(source: $sourceId).get(0)
                $targetId = 'brick-' + connection.target
                $target = jsPlumb.selectEndpoints(target: $targetId).get(connection.targetIndex)
                jsPlumb.connect( { source: $source, target: $target } )

    @$scope.collapse =
      gates: true
      private: false
      public: false

    @$scope.new = =>
      # new brick

    @$scope.copy = =>
      # copy brick

    @$scope.run = =>
      # run brick

    @$scope.export = =>
      # export brick
