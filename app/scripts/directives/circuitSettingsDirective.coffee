app = angular.module("geniusApp")

app.directive "circuitSettings", ($compile, $rootScope) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitSettings)
    jsPlumb.Defaults.Container = element

    $rootScope.connectionStyle =
      # connector: [
      #   "Flowchart"
      #   {
      #     stub: [ 40, 60 ]
      #     gap: 10
      #     cornerRadius: 5
      #     alwaysRespectStubs: true
      #   }
      # ]
      # connectorStyle:
      #   lineWidth: 4
      #   strokeStyle: "#61B7CF"
      #   joinstyle: "round"
      # outlineColor: "transparent"

      # hoverPaintStyle:
      #   fillStyle: "#216477"
      #   strokeStyle: "#216477"

      # connectorHoverStyle:
      #   lineWidth: 4
      #   strokeStyle: "#216477"
      #   outlineColor: "transparent"
        
      # connectorOverlays: [
      #   [
      #     "Custom"
      #       cssClass: "component label"
      #       location: 0.5
      #       create: (component)->
      #         $element = angular.element "<div id='label-#{component.id}' data-connection='#{component.id}' connection-popover>Properties</div>"
      #         $compile($element)($rootScope)
      #         return $element
      #   ]
      #   [
      #     "Arrow"
      #     {
      #       location: 0.2
      #       width: 20
      #       length: 20
      #     }
      #   ]
      #   [
      #     "Arrow"
      #     {
      #       location: 0.8
      #       width: 20
      #       length: 20
      #     }
      #   ]
      # ]

    # the definition of source endpoints (the small blue ones)
    $rootScope.targetEndPoint =
      endpoint: "Dot"
      paintStyle:
        strokeStyle: "#7AB02C"
        fillStyle: "transparent"
        radius: 7
        lineWidth: 3

      isTarget: true
      connector: [
        "Flowchart"
        {
          stub: [ 40, 60 ]
          gap: 10
          cornerRadius: 5
          alwaysRespectStubs: true
        }
      ]
      connectorStyle:
        lineWidth: 4
        strokeStyle: "#61B7CF"
        joinstyle: "round"
      outlineColor: "transparent"

      hoverPaintStyle:
        fillStyle: "#216477"
        strokeStyle: "#216477"

      connectorHoverStyle:
        lineWidth: 4
        strokeStyle: "#216477"
        outlineColor: "transparent"

    $rootScope.sourceEndPoint =
      endpoint: "Dot"
      paintStyle:
        fillStyle: "#7AB02C"
        radius: 11

      maxConnections: 1
      connector: [
        "Flowchart"
        {
          stub: [ 40, 60 ]
          gap: 10
          cornerRadius: 5
          alwaysRespectStubs: true
        }
      ]
      connectorStyle:
        lineWidth: 4
        strokeStyle: "#61B7CF"
        joinstyle: "round"
        outlineColor: "transparent"

      hoverPaintStyle:
        fillStyle: "#216477"
        strokeStyle: "#216477"

      connectorHoverStyle:
        lineWidth: 4
        strokeStyle: "#216477"
        outlineColor: "transparent"

      connectorOverlays: [
        [
          "Custom"
            cssClass: "component label"
            location: 0.5
            create: (component)->
              $element = angular.element "<div id='label-#{component.id}' data-connection='#{component.id}' connection-popover>Properties</div>"
              $compile($element)($rootScope)
              return $element
        ]
        [
          "Arrow"
          {
            location: 0.2
            width: 20
            length: 20
          }
        ]
        [
          "Arrow"
          {
            location: 0.8
            width: 20
            length: 20
          }
        ]
      ]

      isSource: true
