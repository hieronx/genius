app = angular.module("geniusApp")

class BricksCtrl extends BaseCtrl

  @register app, 'BricksCtrl'
  @inject "$scope", "$rootScope", "$timeout", "Brick", "dropService", "simulationService"

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
      @Brick.all().done (bricks) =>
        solution = @simulationService.run(bricks)

        console.log solution

        chartcfg =
          options:
            chart:
              type: "column"

          series: [data: [numeric.transpose([solution.y[0],solution.y[1]])]]

          xAxis: [categories: [
            "old bar title"
            "old bar title 2 "
          ]]

          title:
            text: "Hello"

          loading: false

        @$timeout =>
          @$scope.$apply(=>
            console.log chartcfg
            @$scope.chartConfig = chartcfg
          )
        , 0

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