"use strict"
angular.module("geniusApp").directive "circuitSettings", ($rootScope) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.circuitSettings) #allow options to be passed in
    jsPlumb.Defaults.Container = element
    
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

      # connectorOverlays: [ [ "Arrow", { location:0.5 } ] ]
      connectorOverlays: [
        [
          "Label"
          {
            cssClass: "l1 component label"
            label: "Connection One"
            location: 0.7
            id: "label"
            events:
              click: (label, evt) ->
                alert "clicked on label for connection " + label.component.id
                return
          }
        ]
        [
          "Arrow"
          {
            cssClass: "l1arrow"
            location: 0.2
            width: 20
            length: 20
            events:
              click: (arrow, evt) ->
                alert "clicked on arrow for connection " + arrow.component.id
                return
          }
        ]
      ]

      isSource: true