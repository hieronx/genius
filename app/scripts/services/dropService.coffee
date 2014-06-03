app = angular.module("geniusApp")

app.factory "dropService", ($compile, $rootScope, Brick) ->
  drop: (index, elementScope, ui, newElement) ->
    unless ui.draggable.hasClass("canvas-element")
      $canvas = $('#workspace')

      $canvasElement = ui.draggable.clone()
      $canvasElement.removeAttr('tooltip')

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
        $canvasElement.css
          left: (ui.position.left + "px")
          top: (ui.position.top)
          position: "absolute"

      position = {
        left: $canvasElement.position().left
        top: $canvasElement.position().top
      }
      Brick.update(index, position)

      $canid = "brick-" + index
      $canvasElement.draggable("destroy")

      delBrick = angular.element '<i class="fa fa-times delete-brick" delete-brick></i>'
      $canvasElement.append delBrick
      $compile(delBrick)($rootScope)

      if $canvasElement.hasClass("brick-and")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.2, -1, 0, 8,  0], $rootScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [0, 0.8, -1, 0, 8,  0], $rootScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 1,  0, -8, 0], $rootScope.sourceEndPoint

      else if $canvasElement.hasClass("brick-not")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.5, -1, 0, 8, 0], $rootScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 1,  0], $rootScope.sourceEndPoint

      else if $canvasElement.hasClass("brick-or")
        jsPlumb.addEndpoint $canid, anchor: [-0.02, 0.25, -1, 0, 12, 0], $rootScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [-0.02, 0.75, -1, 0, 12, 0], $rootScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5,  1,  0, -8, 0], $rootScope.sourceEndPoint

      else if $canvasElement.hasClass("brick-input")
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 1, 0, -40, 0], $rootScope.sourceEndPoint

      else if $canvasElement.hasClass("brick-output")
        jsPlumb.addEndpoint $canid, anchor: [0, 0.5, -1, 0, 33, 0], $rootScope.targetEndPoint

      else
        jsPlumb.addEndpoint $canid, anchor: [0, 0.2, -1, 0 ], $rootScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [0, 0.8, -1, 0 ], $rootScope.targetEndPoint
        jsPlumb.addEndpoint $canid, anchor: [1, 0.5, 1, 0 ], $rootScope.sourceEndPoint

      # Enable draggable behaviour and ensure a popover will not appear when dragged
      jsPlumb.draggable $canvasElement,
        # containment: $('#workspace')
        start: (event, ui) ->
          $(this).popover('disable')
        stop: (event, ui) ->
          setTimeout (=>
            $(this).popover('enable')

            $canid = $(this).attr 'id'
            index = $canid.slice 6

            position =
              left: $(this).position().left
              top: $(this).position().top

            Brick.update(index, position)
          ), 0

      # Bricks cannot be dragged when a popover is active
      $canvasElement.on 'click', ->
        $this = $(this)
        if $this.hasClass('dragDisabled')
          if $this.hasClass('labelDisabled')
            $this.removeClass('dragDisabled')
          else
            $this.removeClass('dragDisabled').draggable('enable')
        else
          $this.addClass('dragDisabled')
          $this.draggable('disable')

        # Handles form data when submitted and updates brick in the database
        $canvasElement.next().find('form').on 'submit', (event) ->
          event.preventDefault()
          
          $this = $(this)
          $brickId = $canvasElement.attr('id').slice 6
          $attributes = {}

          $this.find('input').each (key, prop) ->
            $attributes[$(prop).attr('name')] = $(prop).val();

          Brick.update($brickId, $attributes).done (updatedBrick) ->



