
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

    @$scope.collapse =
      gates: true
      private: true
      public: false

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

    @$rootScope.genes = []

    @$rootScope.usedGenes = []

    Gene.all (genes) =>
      @$rootScope.genes = _.sortBy(_.map(genes, (gene) ->
        return gene.attributes.name), (name) -> return name)

    Position.all()
    Connection.all()

    Brick.all (bricks) =>
      @$scope.private = bricks
      @importCSV.storeBiobricks()
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        unless @$rootScope.currentBrick?
          if Config.has('current_brick_id')
            Brick.find Config.get('current_brick_id'), (brick) =>
              @$scope.setCurrentBrick brick
          else
            if Brick.size() > 0
              @$scope.setCurrentBrick Brick.first()
            else
              brick = new Brick
                title: "New Biobrick ##{Brick.size() + 1}"
              brick.save =>
                @$scope.setCurrentBrick brick

    @$scope.flash = (type, message) =>
      error = $("<div class=\"alert alert-#{type}\" style=\"display: none\">#{message}</div>")
      error.append '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
      $("#alerts").append error
      error.slideDown()
      setTimeout (=>
        error.slideUp =>
          error.remove()
      ), 5000

    @$scope.save = =>
      @$rootScope.currentBrick.save()

    @$scope.clearWorkspace = =>
      jsPlumb.detachEveryConnection()
      jsPlumb.deleteEveryEndpoint()
      $("#workspace").empty()

    @$scope.fillWorkspace = =>
      @$rootScope.currentBrick.positions.each (position) =>
        ui =
          draggable: $('.brick-container div.brick.' + position.get('gate'))
          position:
            left: position.get('left')
            top: position.get('top')

        @dropService.drop(position, @$rootScope, ui, false)

      @$rootScope.usedGenes = []

      @$rootScope.currentBrick.connections.each (connection) =>
        if _.indexOf(@$rootScope.usedGenes, connection.attributes.selected) < 0
          @$rootScope.usedGenes.push connection.attributes.selected 

      @$rootScope.currentBrick.connections.each (connection) =>
        $sourceId = connection.get('position_from_id')
        $source = jsPlumb.selectEndpoints(source: $sourceId).get(0)
        $targetId = connection.get('position_to_id')
        $target = jsPlumb.selectEndpoints(target: $targetId).get(connection.get('endpoint_index'))

        jsPlumb.connect( { source: $source, target: $target } )
      
      

    @$scope.new = =>
      brick = new Brick
        title: "New Biobrick ##{Brick.size() + 1}"
      brick.save()
      @$scope.setCurrentBrick brick

    @$scope.destroy = =>
      if confirm("Are you sure you want to remove this brick?")
        @$rootScope.currentBrick.destroy()
        @$scope.setCurrentBrick Brick.first()

    @$scope.run = =>
      try
        solutions = @simulationService.run(@$rootScope.currentBrick)
        console.log solutions
        data = []
        i = 1
        j = 0
        for solution in solutions then do (solution) =>
          temp = numeric.transpose(solution.y)
          console.log temp
          data.push {
            name: "Output" + i + "-mRNA"
            data: temp[0]
            id: "series-" + j
          }
          j++
          data.push { 
            name: "Output" + i + "-Protein"
            data: temp[1]
            id: "series-" + j
          }
          j++
          i++
        @$scope.chartConfig.series = data

        @$scope.chartConfig.loading = false
      catch error
        @$scope.flash 'danger', 'Simulation failed! Your brick is invalid.'
    @$scope.export = =>
      # export brick

    @$scope.setCurrentBrick = (brick) =>
      @$scope.clearWorkspace()
      @$rootScope.currentBrick = brick
      Config.set 'current_brick_id', brick.id()
      @$scope.fillWorkspace()
