
class BricksCtrl extends BaseCtrl

  @register()
  @inject "$scope", "$rootScope", "dropService", "_"

  initialize: ->
    @$scope.gates =
      [
        { type: 'AND' },
        { type: 'NOT' },
        { type: 'INPUT' },
        { type: 'OUTPUT' }
      ]

    @$scope.private = []

    @$scope.public = []

    @$scope.loadStoredBricks = =>
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        Brick.fetch (bricks) =>
          for brick in bricks
            ui =
              draggable: $('.brick-container div.brick.' + brick.get('brick_type'))
              position:
                left: brick.get('left')
                top: brick.get('top')

            @dropService.drop(brick, @$rootScope, ui, false)

          for brick in bricks
            if _.isArray(brick.get('connections'))
              for connection in brick.get('connections')
                $sourceId = 'brick-' + brick.id()
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
