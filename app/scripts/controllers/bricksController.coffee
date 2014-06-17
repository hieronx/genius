app = angular.module('geniusApp')

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
    
    formatXml = (xml) ->
      formatted = ""
      reg = /(>)(<)(\/*)/g
      xml = xml.replace(reg, "$1\r\n$2$3")
      pad = 0
      jQuery.each xml.split("\r\n"), (index, node) ->
        indent = 0
        if node.match(/.+<\/\w[^>]*>$/)
          indent = 0
        else if node.match(/^<\/\w/)
          pad -= 1  unless pad is 0
        else if node.match(/^<\w[^>]*[^\/]>.*$/)
          indent = 1
        else
          indent = 0
        padding = ""
        i = 0

        while i < pad
          padding += "  "
          i++
        formatted += padding + node + "\r\n"
        pad += indent
        return

      formatted

    @$scope.export = =>
      # creating the document
      xmlDeclaration = '<?xml version="1.0" encoding="UTF-8"?>'
      doc = document.implementation.createDocument('http://www.sbml.org/sbml/level1', 'sbml', null)
      model = doc.createElement('model')

      # adding list of parameters
      listOfParameters = doc.createElement('listOfParameters')

      k1 = doc.createElement('parameter')
      k1.setAttribute('name', 'k1')
      k1.setAttribute('value', 1)
      listOfParameters.appendChild(k1)

      model.appendChild(listOfParameters)
      model.setAttribute('name', 'gene_network_model')

      # save and export document
      doc.documentElement.appendChild(model)

      xml = xmlDeclaration + new XMLSerializer().serializeToString(doc)
      console.log formatXml(xml)

      blob = new Blob [formatXml(xml)], { type: 'attachment/xml;charset=utf-8;' }
      saveAs(blob, 'sample.sbml')