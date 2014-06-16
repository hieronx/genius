
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

    @$scope.save = =>
      @$scope.currentBrick.save =>

    Brick.all (bricks) =>
      @$scope.private = bricks

      if Brick.size() > 0
        @$scope.currentBrick = Brick.first()
      else
        @$rootScope.currentBrick = new Brick
          title: "New Biobrick ##{Brick.size() + 1}"
        @$scope.save()

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
        @$scope.currentBrick.positions.each (position) =>
          ui =
            draggable: $('.brick-container div.brick.' + brick.get('brick_type'))
            position:
              left: brick.get('left')
              top: brick.get('top')

          @dropService.drop(brick, @$rootScope, ui, false)

        @$scope.currentBrick.connections.each (connection) =>
          $sourceId = 'brick-' + connection.position_from.id()
          $source = jsPlumb.selectEndpoints(source: $sourceId).get(0)
          $targetId = 'brick-' + connection.position_to.id()
          $target = jsPlumb.selectEndpoints(target: $targetId).get(connection.targetIndex)
            draggable: $('.brick-container div.brick.' + position.get('gate_type'))
            position:
              left: position.get('left')
              top: position.get('top')

          @dropService.drop(position, @$rootScope, ui, false)

        @$scope.currentBrick.connections.each (connection) =>
          $sourceId = 'brick-' + connection.get('position_from_id')
          $source = jsPlumb.selectEndpoints(source: $sourceId).get(0)
          $targetId = 'brick-' + connection.get('position_to_id')
          $target = jsPlumb.selectEndpoints(target: $targetId).get(connection.get('targetIndex'))
          
          jsPlumb.connect( { source: $source, target: $target } )

    @$scope.collapse =
      gates: true
      private: true
      public: false

    @$scope.new = =>
      @$scope.currentBrick = new Brick
        title: "New Biobrick ##{Brick.size() + 1}"
      @$scope.currentBrick.save()

    @$scope.copy = =>
      # copy brick

    @$scope.export = =>
      # export brick

    @$scope.setCurrentBrick = (brick) =>
      @$scope.currentBrick = brick

    @$scope.destroyBrick = (brick) =>
      if confirm("Are you sure you want to remove this brick?")
        brick.destroy()
        @$scope.setCurrentBrick Brick.first()
