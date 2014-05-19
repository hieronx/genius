"use strict"
angular.module("geniusApp").directive "isDroppable", (Block) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDraggable) #allow options to be passed in
    index = 1
    element.droppable drop: (event, ui) ->
      $canvas = $(this)
      unless ui.draggable.hasClass("canvas-element")
        $canvasElement = ui.draggable.clone()
        $canvasElement.addClass "canvas-element"
        $canvasElement.draggable containment: "#workspace"
        $canvasElement.addClass("brick-jsplumb").attr "id", "brick-" + index
        index++
        $canvas.append $canvasElement
        $par = $canvas.parent()
        $canvasElement.css
          left: (ui.position.left + $par.outerWidth() + $par.position().left + "px")
          top: (ui.position.top)
          position: "absolute"

        $canvasElement.draggable "destroy"
        if $canvasElement.hasClass("gate-and")
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              0
              0.2
              -1
              0
            ]
          , scope.targetEndPoint
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              0
              0.8
              -1
              0
            ]
          , scope.targetEndPoint
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              1
              0.5
              0
              0
            ]
          , scope.sourceEndPoint
          Block.add
            left: ui.position.left + $par.outerWidth() + $par.position().left
            top: ui.position.top
            type: "AND"

        else if $canvasElement.hasClass("gate-not")
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              0
              0.5
              -1
              0
            ]
          , scope.targetEndPoint
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              1
              0.5
              0
              0
              7
              0
            ]
          , scope.sourceEndPoint
          Block.add
            left: ui.position.left + $par.outerWidth() + $par.position().left
            top: ui.position.top
            type: "NOT"

        else if $canvasElement.hasClass("gate-or")
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              0
              0.25
              -1
              0
              10
              0
            ]
          , scope.targetEndPoint
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              0
              0.75
              -1
              0
              10
              0
            ]
          , scope.targetEndPoint
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              1
              0.5
              0
              0
            ]
          , scope.sourceEndPoint
          Block.add
            left: ui.position.left + $par.outerWidth() + $par.position().left
            top: ui.position.top
            type: "OR"

        else if $canvasElement.hasClass("gate-input")
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              1
              0.5
              0
              0
              -32
              0
            ]
          , scope.sourceEndPoint
          Block.add
            left: ui.position.left + $par.outerWidth() + $par.position().left
            top: ui.position.top
            type: "input"

        else
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              0
              0.2
              -1
              0
            ]
          , scope.targetEndPoint
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              0
              0.8
              -1
              0
            ]
          , scope.targetEndPoint
          jsPlumb.addEndpoint $canvasElement.attr("id"),
            anchor: [
              1
              0.5
              0
              0
            ]
          , scope.sourceEndPoint
          Block.add
            left: ui.position.left + $par.outerWidth() + $par.position().left
            top: ui.position.top

        jsPlumb.draggable $canvasElement
      return

    return
