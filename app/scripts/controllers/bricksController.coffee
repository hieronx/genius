
class BricksCtrl extends BaseCtrl

  @register()
  @inject "$scope", "$rootScope", "$timeout", "dropService", "importCSV", "simulationService", "_"

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

    @$scope.chartConfig =
      options:
        chart:
          type: "spline"

      title: "Simulation"

      xAxis:
        labels:
          enabled: false

      loading: true

      credits:
        enabled: false

    @$scope.isSaving = false

    Brick.all (bricks) =>
      if bricks.length > 0
        @$scope.currentBrick = Brick.last()
      else
        @$scope.currentBrick = new Brick
          title: "New Biobrick ##{Brick.size() + 1}"
        @$scope.save()

    @$scope.save = =>
      @$scope.isSaving = true
      @$scope.currentBrick.save =>
        @$scope.isSaving = false

    @$scope.run = =>
      Brick.all (bricks) =>

        solution = @simulationService.run(bricks)

        data = numeric.transpose(solution.y)

        console.log data

        @$scope.chartConfig.series = [
          {
            name: "mRNA"
            data: data[0]
            id: "series-0"
          },
          {
            name: "Protein"
            data: data[1]
            id: "series-1"
          }
        ]

        @$scope.chartConfig.loading = false

    @$scope.loadStoredBricks = =>
      @importCSV.storeBiobricks()
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        Brick.all (bricks) =>
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
      @$scope.currentBrick = new Brick
        title: "New Biobrick ##{Brick.size() + 1}"
      @$scope.currentBrick.save()

    @$scope.copy = =>
      # copy brick

    @$scope.export = =>
      # export brick
