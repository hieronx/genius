app = angular.module("geniusApp")

class BricksCtrl extends BaseCtrl

  @register app, 'BricksCtrl'
  @inject "$scope", "$rootScope", "$timeout", "Brick", "dropService", "importCSV", "simulationService", "_"

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

    @$scope.run = =>
      @Brick.all().done (bricks) =>

        solution = @simulationService.run(bricks)

        data = numeric.transpose(solution.y)

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

    @$scope.export = =>
      doc = document.implementation.createDocument(null, "sbml", null)

      model = doc.createElement("model")
      listOfParameters = doc.createElement("listOfParameters")

      k1 = doc.createElement('parameter')
      k1.setAttribute('name', 'k1')
      k1.setAttribute('value', 1)
      listOfParameters.appendChild(k1)

      model.appendChild(listOfParameters)
      doc.documentElement.appendChild(model)

      xml = new XMLSerializer().serializeToString(doc)
      blob = new Blob [xml], { type: "attachment/xml;charset=utf-8;" }
      saveAs(blob, "sample.sbml")