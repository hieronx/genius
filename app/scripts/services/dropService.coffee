app = angular.module("geniusApp")

app.factory "dropService", ($compile, $rootScope) ->
  index = 1
  drop: (elementScope, ui, newElement) ->
    unless ui.draggable.hasClass("canvas-element")
      $canvas = $('#workspace')

      $canvasElement = ui.draggable.clone()
      $canvasElement.addClass "canvas-element"
      $canvasElement.draggable containment: "#workspace"
      $canvasElement.addClass("brick-jsplumb").attr "id", "brick-" + index
      $canvasElement.attr('brick-popover', "")
      $compile($canvasElement)($rootScope)
      $canvas.append $canvasElement

      $par = $canvas.parent()
      if newElement
        $canvasElement.css
          left: (ui.position.left + $par.outerWidth() + $par.position().left + "px")
          top: (ui.position.top)
          position: "absolute"
      else
        console.log($canvasElement)
        $canvasElement.css
          left: (ui.position.left + "px")
          top: (ui.position.top)
          position: "absolute"
        console.log($canvasElement)
        console.log("-------------------------------------------")

      $canid = "brick-" + index

      $canvasElement.draggable("destroy")

      delBrick = angular.element '<i class="fa fa-times delete-brick" delete-brick></i>'
      $canvasElement.append delBrick
      $compile(delBrick)($rootScope)

      if $canvasElement.hasClass("brick-and")
        jsPlumb.addEndpoint($canid, anchor: [0, 0.2, -1, 0 ], elementScope.targetEndPoint).addOverlay([ "Arrow", { width:10, height:10, id:"arrow" }]);
        jsPlumb.addEndpoint($canid, anchor: [0, 0.8, -1, 0 ], elementScope.targetEndPoint).addOverlay([ "Arrow", { width:10, height:10, id:"arrow" }]);
        jsPlumb.addEndpoint($canid, anchor: [1, 0.5, 0, 0 ], elementScope.sourceEndPoint).addOverlay([ "Arrow", { width:10, height:10, id:"arrow" }]);

      else if $canvasElement.hasClass("brick-not")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.5, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0, 7, 0 ], elementScope.sourceEndPoint

      else if $canvasElement.hasClass("brick-or")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.25, -1, 0, 10, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [0, 0.75, -1, 0, 10, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0, ], elementScope.sourceEndPoint

      else if $canvasElement.hasClass("brick-input")
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0, -32, 0 ], elementScope.sourceEndPoint

      else if $canvasElement.hasClass("brick-output")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.5, -1, 0, 25, 0 ], elementScope.targetEndPoint

      else
        jsPlumb.addEndpoint $canid, anchor: [0, 0.2, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [0, 0.8, -1, 0 ], elementScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 0, 0 ], elementScope.sourceEndPoint

      index++

      jsPlumb.draggable $canvasElement,
        # containment: $('#workspace')
        start: (event, ui) ->
          $(this).popover('disable')
        stop: (event, ui) ->
          setTimeout (=>
            $(this).popover('enable')
          ), 0
      
      $canvasElement.on 'click', ->
        $this = $(this)
        if $this.hasClass('dragDisabled')
          $this.removeClass('dragDisabled')
          $this.draggable('enable')
        else
          $this.addClass('dragDisabled')
          $this.draggable('disable')
      
