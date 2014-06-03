app = angular.module("geniusApp")

app.directive "isDroppable", (Brick, $compile, $rootScope, dropService) ->
  restrict: "A"
  link: (scope, element, attributes) ->
    options = scope.$eval(attributes.isDroppable) #allow options to be passed in
    element.droppable drop: (event, ui) ->
      if ui.draggable.hasClass 'canvas-element'
        $canid = ui.draggable.attr 'id'
        index = $canid.slice 6

        console.log index

        dropService.drop(index, scope, ui, false)

      else
        $canvas = $(this)
        $par = $canvas.parent()

        if ui.draggable.hasClass("brick-and")
          brick =
            brick_type: 'brick-and'

        else if ui.draggable.hasClass("brick-or")
          brick =
            brick_type: 'brick-or'

        else if ui.draggable.hasClass("brick-not")
          brick =
            brick_type: 'brick-not'

        else if ui.draggable.hasClass("brick-input")
          brick =
            brick_type: 'brick-input'

        else if ui.draggable.hasClass("brick-output")
          brick =
            brick_type: 'brick-output'

        Brick.add(brick).done (newBrick) ->
          dropService.drop(newBrick.id, scope, ui, true)