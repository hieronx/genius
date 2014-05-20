'use strict'
angular.module("geniusApp").factory "dropService", ($compile, $rootScope) ->
  index = 1
  drop: (elementScope, ui, newElement) ->
    unless ui.draggable.hasClass("canvas-element")
      $canvas = $('#workspace')
      console.log($canvas)

      $canvasElement = ui.draggable.clone()
      $canvasElement.addClass "canvas-element"
      $canvasElement.draggable containment: "#workspace"
      $canvasElement.addClass("brick-jsplumb").attr "id", "brick-" + index
      $canvas.append $canvasElement

      $par = $canvas.parent()
      if newElement
        $canvasElement.css
          left: (ui.position.left + $par.outerWidth() + $par.position().left + "px")
          top: (ui.position.top)
          position: "absolute"
      else
        $canvasElement.css
          left: (ui.position.left + "px")
          top: (ui.position.top)
          position: "absolute"

      $canid = $canvasElement.attr('id')

      $canvasElement.draggable "destroy"

      delBrick = angular.element '<i class="fa fa-times delete-brick" delete-brick></i>'       
      $canvasElement.append delBrick ;
      $compile(delBrick)($rootScope);

      if $canvasElement.hasClass("gate-and")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.2, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [0, 0.8, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0 ], elementScope.sourceEndPoint

      else if $canvasElement.hasClass("gate-not")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.5, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0, 7, 0 ], elementScope.sourceEndPoint

      else if $canvasElement.hasClass("gate-or")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.25, -1, 0, 10, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [0, 0.75, -1, 0, 10, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0, ], elementScope.sourceEndPoint

      else if $canvasElement.hasClass("gate-input")
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0, -32, 0 ], elementScope.sourceEndPoint

      else if $canvasElement.hasClass("gate-output")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.5, -1, 0, 25, 0 ], elementScope.targetEndPoint

      else
        jsPlumb.addEndpoint $canid, anchor: [0, 0.2, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [0, 0.8, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0 ], elementScope.sourceEndPoint

      jsPlumb.draggable $canvasElement

      index++