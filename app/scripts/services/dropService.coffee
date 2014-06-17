app = angular.module("geniusApp")

app.factory "dropService", ($compile, $rootScope) ->
  drop: (position, elementScope, ui, newElement) ->
    console.log position

    # Switch from detachable to not detachable mode or the other way around
    setDetachable = ($endpoint, type) ->
      $endpoint.bind "mousedown", (endpoint) ->
        if type is 'target'
          endpoint.connections[0].setDetachable(true)
        else
          endpoint.connections[0].setDetachable(false)

    unless ui.draggable.hasClass("canvas-element")
      $canvas = $('#workspace')

      $canvasElement = ui.draggable.clone()
      $canvasElement.removeAttr('tooltip')

      $canvasElement.addClass "canvas-element"
      $canvasElement.draggable containment: "#workspace"
      $canvasElement.addClass("brick-jsplumb").attr "id", position.id()
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

      position.set 'left', $canvasElement.position().left
      position.set 'top', $canvasElement.position().top

      position.save =>
        pid = position.id()
        $canvasElement.draggable("destroy")

        delBrick = angular.element '<i class="fa fa-times delete-position" delete-position></i>'
        $canvasElement.append delBrick
        $compile(delBrick)($rootScope)
        
        if $canvasElement.hasClass("brick-and")
          $endpoint = jsPlumb.addEndpoint pid, anchor: [0, 0.2, -1, 0, 8,  0], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
          $endpoint = jsPlumb.addEndpoint pid, anchor: [0, 0.8, -1, 0, 8,  0], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
          $endpoint = jsPlumb.addEndpoint pid, anchor: [1, 0.5, 1,  0, -8, 0], $rootScope.sourceEndPoint
          setDetachable($endpoint, 'source')
        else if $canvasElement.hasClass("brick-not")
          $endpoint = jsPlumb.addEndpoint pid, anchor: [0, 0.5, -1, 0, 8, 0], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
          $endpoint = jsPlumb.addEndpoint pid, anchor: [1, 0.5, 1,  0], $rootScope.sourceEndPoint
          setDetachable($endpoint, 'source')
        else if $canvasElement.hasClass("brick-or")
          $endpoint = jsPlumb.addEndpoint pid, anchor: [-0.02, 0.25, -1, 0, 12, 0], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
          $endpoint = jsPlumb.addEndpoint pid, anchor: [-0.02, 0.75, -1, 0, 12, 0], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
          $endpoint = jsPlumb.addEndpoint pid, anchor: [1, 0.5,  1,  0, -8, 0], $rootScope.sourceEndPoint
          setDetachable($endpoint, 'source')
        else if $canvasElement.hasClass("brick-input")
          $endpoint = jsPlumb.addEndpoint pid, { anchor: [1, 0.5, 1, 0, -40, 0] }, $rootScope.sourceEndPoint
          setDetachable($endpoint, 'source')
        else if $canvasElement.hasClass("brick-output")
          $endpoint = jsPlumb.addEndpoint pid, anchor: [0, 0.5, -1, 0, 33, 0], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
        else
          $endpoint = jsPlumb.addEndpoint pid, anchor: [0, 0.2, -1, 0 ], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
          $endpoint = jsPlumb.addEndpoint pid, anchor: [0, 0.8, -1, 0 ], $rootScope.targetEndPoint
          setDetachable($endpoint, 'target')
          $endpoint = jsPlumb.addEndpoint pid, anchor: [1, 0.5, 1, 0 ], $rootScope.sourceEndPoint
          setDetachable($endpoint, 'source')

        # Enable draggable behaviour and ensure a popover will not appear when dragged
        jsPlumb.draggable $canvasElement,
          # containment: $('#workspace')
          start: (event, ui) ->
            $(this).popover('disable')
          stop: (event, ui) ->
            setTimeout (=>
              $(this).popover('enable')

              pid = $(this).attr('id')
              Position.find pid, (position) =>
                #position ||= Position.collection[pid] # why the hell is this necessary?
                position.set 'left', $(this).position().left
                position.set 'top', $(this).position().top
                position.save()
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

            pid = $canvasElement.attr('id')
            Position.find pid, (position) =>

              $(this).find('input').each (key, prop) ->
                position.set $(prop).attr('name'), $(prop).val()
              position.save()
